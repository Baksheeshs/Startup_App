// DataModel.swift
// NiveshSaathi — Complete Data Model
// All models, enums, and the ProfileStore live here.
// Swap ProfileStore's backend to SwiftData in v2 without touching any ViewModel.

import Foundation
import Observation

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
    case none        = "None"
    case oneOrTwo    = "1–2"
    case threeOrMore = "3+"
}

enum RiskLevel: String, Codable, CaseIterable {
    case conservative = "Conservative"
    case moderate     = "Moderate"
    case aggressive   = "Aggressive"

    /// Warikoo's plain-language risk test description shown to user
    var riskDescription: String {
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
    case fixedDeposit       = "Fixed deposit"
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

enum AgeBracket: String, Codable {
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

    /// Months of emergency fund recommended
    var emergencyFundMonths: Int { return 6 }
}

enum SafetyWarning: Codable, Equatable {
    case noTermInsurance
    case noHealthInsurance
    case emergencyFundIncomplete(gap: Double)

    var title: String {
        switch self {
        case .noTermInsurance:         return "Get term insurance first"
        case .noHealthInsurance:       return "Get health insurance first"
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
    var existingEmergencyFund: Double
    var existingInvestments: [AssetClass]
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

// ─────────────────────────────────────────────
// MARK: — Layer 1: Salary Allocation
// ─────────────────────────────────────────────

struct AllocationBucket: Codable, Identifiable {
    let id: UUID
    var label: String
    var amount: Double
    var colorName: String       // Asset catalog color name, used by UI

    init(label: String, amount: Double, colorName: String) {
        self.id        = UUID()
        self.label     = label
        self.amount    = amount
        self.colorName = colorName
    }
}

struct SalaryAllocation: Codable, Identifiable {
    let id: UUID
    let userProfileId: UUID
    let incomeDataId: UUID
    var rent: Double
    var dailyExpenses: Double
    var lifestyle: Double
    var termInsurancePremium: Double
    var healthInsurancePremium: Double
    var emergencySIP: Double            // liquid fund SIP — NOT investment
    var investmentBucket: Double        // THIS feeds Layer 2
    var flexBuffer: Double
    var totalAllocated: Double
    var generatedAt: Date

    /// Convenience: all buckets as ordered array for UI rendering
    var buckets: [AllocationBucket] {
        [
            AllocationBucket(label: "Rent / housing",           amount: rent,                   colorName: "AllocationGray"),
            AllocationBucket(label: "Daily expenses",           amount: dailyExpenses,           colorName: "AllocationGray"),
            AllocationBucket(label: "Lifestyle / wants",        amount: lifestyle,               colorName: "AccentPurple"),
            AllocationBucket(label: "Term insurance",           amount: termInsurancePremium,    colorName: "SafetyGreen"),
            AllocationBucket(label: "Health insurance",         amount: healthInsurancePremium,  colorName: "SafetyGreen"),
            AllocationBucket(label: "Emergency fund SIP",       amount: emergencySIP,            colorName: "WarningAmber"),
            AllocationBucket(label: "Investment bucket",        amount: investmentBucket,        colorName: "AccentPurple"),
            AllocationBucket(label: "Flex / buffer",            amount: flexBuffer,              colorName: "BufferGray"),
        ]
    }
}

// ─────────────────────────────────────────────
// MARK: — Layer 2: Investment Plan & Buckets
// ─────────────────────────────────────────────

struct InvestmentBucket: Codable, Identifiable {
    let id: UUID
    let investmentPlanId: UUID
    var assetClass: AssetClass
    var percentage: Double          // of totalInvestable
    var monthlyAmount: Double
    var tag: BucketTag
    var whyExplanation: String      // Warikoo-style plain language shown in UI
    var suggestedInstrument: String
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

// ─────────────────────────────────────────────
// MARK: — Financial Goals
// ─────────────────────────────────────────────

struct FinancialGoal: Codable, Identifiable {
    let id: UUID
    let userProfileId: UUID
    var goalType: InvestmentGoal
    var goalName: String
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
// MARK: — Snapshot History
// ─────────────────────────────────────────────

/// Saved every time user updates income or re-generates their plan.
struct SnapshotHistory: Codable, Identifiable {
    let id: UUID
    let userProfileId: UUID
    var salaryAtSnapshot: Double
    var ageAtSnapshot: Int
    var investmentBucketAmount: Double
    var totalInvestedTillDate: Double
    var planSummaryJSON: String
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
        self.planSummaryJSON        = Self.encodePlan(plan)
    }

    private static func encodePlan(_ plan: InvestmentPlan) -> String {
        do {
            let data = try JSONEncoder().encode(plan)
            return String(data: data, encoding: .utf8) ?? "{}"
        } catch {
            assertionFailure("Failed to encode InvestmentPlan: \(error)")
            return "{}"
        }
    }

    func decodePlan() -> InvestmentPlan? {
        guard let data = planSummaryJSON.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(InvestmentPlan.self, from: data)
    }
}

// ─────────────────────────────────────────────
// MARK: — App State Container
// ─────────────────────────────────────────────

/// The root object held by ProfileStore and injected via @Environment.
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
@Observable
final class ProfileStore {

    // MARK: — State
    var state: AppState = AppState()

    // MARK: — Dependencies
    @ObservationIgnored private let key = "niveshsaathi.appstate.v1"
    @ObservationIgnored private let encoder = JSONEncoder()
    @ObservationIgnored private let decoder = JSONDecoder()

    // MARK: — Init
    init() { load() }

    // MARK: — Intents

    func save() {
        guard let data = try? encoder.encode(state) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? decoder.decode(AppState.self, from: data)
        else { return }
        state = decoded
    }

    func reset() {
        state = AppState()
        UserDefaults.standard.removeObject(forKey: key)
    }
}
