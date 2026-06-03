//
//  DataModel.swift
//  Stratup_App
//
//  Created by Baksheesh Singh on 02/06/26.
//

// WealthWise — Complete Data Model
// All models are value types (struct) + Codable for UserDefaults persistence in v1.
// Swap ProfileStore's backend to SwiftData/CoreData in v2 without touching any ViewModel.
 
import Foundation
internal import Combine

// ─────────────────────────────────────────────
// MARK: — Enumerations
// ─────────────────────────────────────────────
 
enum IncomeType: String, Codable, CaseIterable {
    case salaried   = "Salaried"
    case freelance  = "Freelance"
    case business   = "Business"
    case student    = "Student / No income yet"
}
 
enum DependantTier: String, Codable, CaseIterable {
    case none       = "None"
    case oneOrTwo   = "1–2"
    case threeOrMore = "3+"
}
 
enum RiskLevel: String, Codable, CaseIterable {
    case conservative = "Conservative"
    case moderate     = "Moderate"
    case aggressive   = "Aggressive"
 
    /// Warikoo's plain-language risk test description shown to user
    var description: String {
        switch self {
        case .conservative: return "I prefer stability. A 20% portfolio drop would make me sell."
        case .moderate:     return "I can hold steady through a 30–40% drop without panic."
        case .aggressive:   return "I understand markets. A 50% drop won't make me sell."
        }
    }
}
 
enum InvestmentGoal: String, Codable, CaseIterable {
    case wealthBuilding = "General wealth building"
    case retirement     = "Retirement corpus"
    case house          = "Buy a house"
    case childEducation = "Child's education"
    case travel         = "Travel fund"
    case car            = "Buy a car"
    case emergencyBuild = "Build emergency fund"
}
 
enum GoalStatus: String, Codable {
    case notStarted = "Not started"
    case inProgress = "In progress"
    case achieved   = "Achieved"
    case paused     = "Paused"
}
 
enum AssetClass: String, Codable, CaseIterable {
    case equityMutualFund   = "Equity mutual funds (SIP)"
    case ppf                = "PPF"
    case nps                = "NPS"
    case digitalGold        = "Digital gold / SGBs"
    case debtFund           = "Debt mutual funds"
    case fixedDeposit        = "Fixed deposit"
    case usStocks           = "US stocks / ETFs"
    case directStocks       = "Direct Indian stocks"
    case liquidFund         = "Liquid fund (emergency)"
    case epfVpf             = "EPF / VPF top-up"
 
    var riskCategory: String {
        switch self {
        case .equityMutualFund, .directStocks, .usStocks: return "High growth"
        case .ppf, .nps, .epfVpf:                         return "Safe + tax-free"
        case .digitalGold:                                 return "Inflation hedge"
        case .debtFund, .liquidFund:                       return "Stable"
        case .fixedDeposit:                                return "Capital protection"
        }
    }
}
 
enum BucketTag: String, Codable {
    case grow   = "grow"    // High growth, equity-type instruments
    case safe   = "safe"    // PPF, debt, gold — stable
    case avoid  = "avoid"   // FDs for young aggressive investors, etc.
}
 
// ─────────────────────────────────────────────
// MARK: — Core Entities
// ─────────────────────────────────────────────
 
/// Root entity. Everything hangs off this.
struct UserProfile: Codable, Identifiable {
    let id: UUID
    var name: String
    var age: Int
    var city: String
    var incomeType: IncomeType
    var dependants: DependantTier
    var createdAt: Date
    var updatedAt: Date
 
    init(name: String, age: Int, city: String,
         incomeType: IncomeType, dependants: DependantTier) {
        self.id         = UUID()
        self.name       = name
        self.age        = age
        self.city       = city
        self.incomeType = incomeType
        self.dependants = dependants
        self.createdAt  = Date()
        self.updatedAt  = Date()
    }
 
    /// Age bracket drives equity %, SIP advice, and risk messaging
    var ageBracket: AgeBracket {
        switch age {
        case ..<22:  return .earlyCareer
        case 22..<30: return .youngProfessional
        case 30..<40: return .midCareer
        case 40..<50: return .preRetirement
        default:     return .retirement
        }
    }
}
 
enum AgeBracket: String {
    case earlyCareer       = "Early career (< 22)"
    case youngProfessional = "Young professional (22–29)"
    case midCareer         = "Mid career (30–39)"
    case preRetirement     = "Pre-retirement (40–49)"
    case retirement        = "Retirement (50+)"
 
    /// Recommended equity % of investable amount — Warikoo's age-based rule
    var recommendedEquityPercent: Double {
        switch self {
        case .earlyCareer:       return 0.75
        case .youngProfessional: return 0.65
        case .midCareer:         return 0.55
        case .preRetirement:     return 0.40
        case .retirement:        return 0.25
        }
    }
 
    /// Months of emergency fund recommended (freelancers get +3)
    var emergencyFundMonths: Int { return 6 }
}
 
// ─────────────────────────────────────────────
// MARK: — Income & Expenses
// ─────────────────────────────────────────────
 
struct IncomeData: Codable, Identifiable {
    let id: UUID
    let userProfileId: UUID
    var monthlyIncome: Double
    var otherIncome: Double          // rent received, dividends, freelance side income
    var monthlyExpenses: Double      // rent paid + daily + utilities (user-entered)
    var emiObligations: Double       // existing loan EMIs
    var hasSalaryHike: Bool          // flag: user anticipates a raise
    var projectedIncome: Double      // optional: post-hike expected income
    var recordedAt: Date
 
    init(userProfileId: UUID, monthlyIncome: Double, otherIncome: Double = 0,
         monthlyExpenses: Double, emiObligations: Double = 0,
         hasSalaryHike: Bool = false, projectedIncome: Double = 0) {
        self.id               = UUID()
        self.userProfileId    = userProfileId
        self.monthlyIncome    = monthlyIncome
        self.otherIncome      = otherIncome
        self.monthlyExpenses  = monthlyExpenses
        self.emiObligations   = emiObligations
        self.hasSalaryHike    = hasSalaryHike
        self.projectedIncome  = projectedIncome
        self.recordedAt       = Date()
    }
 
    var totalIncome: Double { monthlyIncome + otherIncome }
 
    /// Raw surplus before the allocation engine runs
    var rawSurplus: Double { totalIncome - monthlyExpenses - emiObligations }
 
    /// Freelancers have variable income: conservative 70% of stated income
    func effectiveIncome(for incomeType: IncomeType) -> Double {
        switch incomeType {
        case .freelance, .business: return totalIncome * 0.70
        default: return totalIncome
        }
    }
}
 
// ─────────────────────────────────────────────
// MARK: — Risk & Goals
// ─────────────────────────────────────────────
 
struct RiskProfile: Codable, Identifiable {
    let id: UUID
    let userProfileId: UUID
    var riskLevel: RiskLevel
    var primaryGoal: InvestmentGoal
    var investmentHorizonYears: Int
    var hasTermInsurance: Bool
    var hasHealthInsurance: Bool
    var hasEmergencyFund: Bool
    var existingEmergencyFund: Double   // amount already saved in liquid/savings
    var existingInvestments: [AssetClass]  // what they already have
    var assessedAt: Date
 
    init(userProfileId: UUID, riskLevel: RiskLevel, primaryGoal: InvestmentGoal,
         investmentHorizonYears: Int, hasTermInsurance: Bool, hasHealthInsurance: Bool,
         hasEmergencyFund: Bool, existingEmergencyFund: Double,
         existingInvestments: [AssetClass] = []) {
        self.id                     = UUID()
        self.userProfileId          = userProfileId
        self.riskLevel              = riskLevel
        self.primaryGoal            = primaryGoal
        self.investmentHorizonYears = investmentHorizonYears
        self.hasTermInsurance       = hasTermInsurance
        self.hasHealthInsurance     = hasHealthInsurance
        self.hasEmergencyFund       = hasEmergencyFund
        self.existingEmergencyFund  = existingEmergencyFund
        self.existingInvestments    = existingInvestments
        self.assessedAt             = Date()
    }
}
 
// ─────────────────────────────────────────────
// MARK: — Safety Check (Warikoo's prerequisites)
// ─────────────────────────────────────────────
 
struct SafetyCheck: Codable, Identifiable {
    let id: UUID
    let userProfileId: UUID
    var termInsuranceOk: Bool
    var healthInsuranceOk: Bool
    var emergencyFundOk: Bool
    var emergencyFundTarget: Double     // 6 × monthly expenses
    var emergencyFundCurrent: Double
    var safetyScore: Int                // 0–100, shown as progress ring in UI
    var checkedAt: Date
 
    var emergencyFundGap: Double {
        max(0, emergencyFundTarget - emergencyFundCurrent)
    }
 
    /// Blocking warnings — shown BEFORE any investment suggestion
    var blockingWarnings: [SafetyWarning] {
        var warnings: [SafetyWarning] = []
        if !termInsuranceOk    { warnings.append(.noTermInsurance) }
        if !healthInsuranceOk  { warnings.append(.noHealthInsurance) }
        if emergencyFundGap > 0 { warnings.append(.emergencyFundIncomplete(gap: emergencyFundGap)) }
        return warnings
    }
}
 
enum SafetyWarning: Equatable {
    case noTermInsurance
    case noHealthInsurance
    case emergencyFundIncomplete(gap: Double)
 
    var title: String {
        switch self {
        case .noTermInsurance:    return "Get term insurance first"
        case .noHealthInsurance:  return "Get health insurance first"
        case .emergencyFundIncomplete: return "Emergency fund incomplete"
        }
    }
 
    var explanation: String {
        switch self {
        case .noTermInsurance:
            return "Warikoo's rule #1: before investing a single rupee, get a term plan. ₹1 crore cover costs ~₹500–800/mo at your age."
        case .noHealthInsurance:
            return "A single hospitalisation can wipe out years of savings. Health insurance is not optional."
        case .emergencyFundIncomplete(let gap):
            return "You need ₹\(Int(gap).formatted()) more in a liquid fund before starting equity SIPs."
        }
    }
}
 
// ─────────────────────────────────────────────
// MARK: — Layer 1: Salary Allocation
// ─────────────────────────────────────────────
 
struct SalaryAllocation: Codable, Identifiable {
    let id: UUID
    let userProfileId: UUID
    let incomeDataId: UUID
    var rent: Double
    var dailyExpenses: Double
    var lifestyle: Double               // wants, dining, entertainment
    var termInsurancePremium: Double
    var healthInsurancePremium: Double
    var emergencySIP: Double            // liquid fund SIP — NOT investment
    var investmentBucket: Double        // THIS feeds Layer 2
    var flexBuffer: Double              // rounding/remainder
    var totalAllocated: Double
    var generatedAt: Date
 
    /// Convenience: all buckets as ordered array for UI rendering
    var buckets: [AllocationBucket] {
        [
            AllocationBucket(label: "Rent / housing",           amount: rent,                   color: "#888780"),
            AllocationBucket(label: "Daily expenses",           amount: dailyExpenses,           color: "#888780"),
            AllocationBucket(label: "Lifestyle / wants",        amount: lifestyle,               color: "#AFA9EC"),
            AllocationBucket(label: "Term insurance",           amount: termInsurancePremium,    color: "#1D9E75"),
            AllocationBucket(label: "Health insurance",         amount: healthInsurancePremium,  color: "#1D9E75"),
            AllocationBucket(label: "Emergency fund SIP",       amount: emergencySIP,            color: "#EF9F27"),
            AllocationBucket(label: "Investment bucket",        amount: investmentBucket,        color: "#7F77DD"),
            AllocationBucket(label: "Flex / buffer",            amount: flexBuffer,              color: "#D3D1C7"),
        ]
    }
}
 
struct AllocationBucket: Codable, Identifiable {
    let id = UUID()
    var label: String
    var amount: Double
    var color: String           // hex, used by Swift Charts
}
 
// ─────────────────────────────────────────────
// MARK: — Layer 2: Investment Plan & Buckets
// ─────────────────────────────────────────────
 
struct InvestmentPlan: Codable, Identifiable {
    let id: UUID
    let userProfileId: UUID
    let salaryAllocationId: UUID
    var totalInvestable: Double
    var ageAtGeneration: Int
    var riskAtGeneration: RiskLevel
    var buckets: [InvestmentBucket]
    var isActive: Bool
    var generatedAt: Date
 
    /// Sum sanity check — should equal totalInvestable
    var allocatedTotal: Double {
        buckets.reduce(0) { $0 + $1.monthlyAmount }
    }
 
    /// 30-year projection at assumed CAGR (equity-weighted)
    func projectedCorpus(years: Int = 30) -> Double {
        let monthlyEquity = buckets
            .filter { $0.tag == .grow }
            .reduce(0.0) { $0 + $1.monthlyAmount }
        let rate = 0.12 / 12
        let n = Double(years * 12)
        return monthlyEquity * ((pow(1 + rate, n) - 1) / rate) * (1 + rate)
    }
}
 
struct InvestmentBucket: Codable, Identifiable {
    let id: UUID
    let investmentPlanId: UUID
    var assetClass: AssetClass
    var percentage: Double          // of totalInvestable
    var monthlyAmount: Double
    var tag: BucketTag
    var whyExplanation: String      // Warikoo-style plain language shown in UI
    var suggestedInstrument: String // e.g. "Nifty 50 index fund (Zerodha Coin / Groww)"
    var updatedAt: Date
 
    init(investmentPlanId: UUID, assetClass: AssetClass, percentage: Double,
         monthlyAmount: Double, tag: BucketTag,
         whyExplanation: String, suggestedInstrument: String) {
        self.id                  = UUID()
        self.investmentPlanId    = investmentPlanId
        self.assetClass          = assetClass
        self.percentage          = percentage
        self.monthlyAmount       = monthlyAmount
        self.tag                 = tag
        self.whyExplanation      = whyExplanation
        self.suggestedInstrument = suggestedInstrument
        self.updatedAt           = Date()
    }
}
 
// ─────────────────────────────────────────────
// MARK: — Financial Goals
// ─────────────────────────────────────────────
 
struct FinancialGoal: Codable, Identifiable {
    let id: UUID
    let userProfileId: UUID
    var goalType: InvestmentGoal
    var goalName: String            // user-editable label, e.g. "Goa trip 2026"
    var targetAmount: Double
    var targetYears: Int
    var currentSaved: Double
    var status: GoalStatus
    var createdAt: Date
 
    init(userProfileId: UUID, goalType: InvestmentGoal, goalName: String,
         targetAmount: Double, targetYears: Int, currentSaved: Double = 0) {
        self.id             = UUID()
        self.userProfileId  = userProfileId
        self.goalType       = goalType
        self.goalName       = goalName
        self.targetAmount   = targetAmount
        self.targetYears    = targetYears
        self.currentSaved   = currentSaved
        self.status         = .notStarted
        self.createdAt      = Date()
    }
 
    /// Monthly SIP needed to hit goal, assuming 12% CAGR
    var monthlySIPNeeded: Double {
        let remaining = targetAmount - currentSaved
        guard remaining > 0, targetYears > 0 else { return 0 }
        let n = Double(targetYears * 12)
        let r = 0.12 / 12
        return remaining * r / (pow(1 + r, n) - 1)
    }
 
    var progressPercent: Double {
        guard targetAmount > 0 else { return 0 }
        return min(1.0, currentSaved / targetAmount)
    }
}
 
// ─────────────────────────────────────────────
// MARK: — Snapshot History (for progress tracking)
// ─────────────────────────────────────────────
 
/// Saved every time user updates income or re-generates their plan.
/// Powers the "your journey" timeline in the app.
struct SnapshotHistory: Codable, Identifiable {
    let id: UUID
    let userProfileId: UUID
    var salaryAtSnapshot: Double
    var ageAtSnapshot: Int
    var investmentBucketAmount: Double
    var totalInvestedTillDate: Double   // user self-reported or derived from past snapshots
    var planSummaryJSON: String         // serialised InvestmentPlan for archiving
    var snapshotDate: Date
 
    init(userProfileId: UUID, salaryAtSnapshot: Double, ageAtSnapshot: Int,
         investmentBucketAmount: Double, totalInvestedTillDate: Double,
         plan: InvestmentPlan) {
        self.id                     = UUID()
        self.userProfileId          = userProfileId
        self.salaryAtSnapshot       = salaryAtSnapshot
        self.ageAtSnapshot          = ageAtSnapshot
        self.investmentBucketAmount = investmentBucketAmount
        self.totalInvestedTillDate  = totalInvestedTillDate
        self.snapshotDate           = Date()
        let encoded = try? JSONEncoder().encode(plan)
        self.planSummaryJSON = encoded.flatMap { String(data: $0, encoding: .utf8) } ?? "{}"
    }
}
 
// ─────────────────────────────────────────────
// MARK: — App State Container (single source of truth)
// ─────────────────────────────────────────────
 
/// The root object held by ProfileStore and injected as @EnvironmentObject.
/// Every ViewModel reads and writes through this.
struct AppState: Codable {
    var userProfile: UserProfile?
    var incomeData: IncomeData?
    var riskProfile: RiskProfile?
    var safetyCheck: SafetyCheck?
    var salaryAllocation: SalaryAllocation?
    var activePlan: InvestmentPlan?
    var goals: [FinancialGoal] = []
    var snapshots: [SnapshotHistory] = []
 
    /// True only when all onboarding steps are complete
    var isOnboardingComplete: Bool {
        userProfile != nil &&
        incomeData  != nil &&
        riskProfile != nil
    }
}
 
// ─────────────────────────────────────────────
// MARK: — Persistence Layer
// ─────────────────────────────────────────────
 
/// v1: UserDefaults-backed store. Replace body with SwiftData in v2.
final class ProfileStore: ObservableObject {
    @Published var state: AppState = AppState()
 
    private let key = "wealthwise.appstate.v1"
 
    init() { load() }
 
    func save() {
        guard let data = try? JSONEncoder().encode(state) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
 
    func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode(AppState.self, from: data)
        else { return }
        state = decoded
    }
 
    func reset() {
        state = AppState()
        UserDefaults.standard.removeObject(forKey: key)
    }
}
 
