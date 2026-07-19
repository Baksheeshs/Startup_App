// DataModel.swift
// WealthWise — Complete Data Model
// All models, enums, sample data, and the ProfileStore live here.

import Foundation
import Observation
import SwiftUI

// ─────────────────────────────────────────────
// MARK: — Enumerations
// ─────────────────────────────────────────────

enum IncomeType: String, Codable, CaseIterable {
    case salaried   = "Salaried"
    case freelance  = "Freelance"
    case business   = "Business"
    case student    = "Student / No income yet"
}

enum RiskLevel: String, Codable, CaseIterable {
    case low          = "Low"
    case moderate     = "Moderate"
    case high         = "High"

    var description: String {
        switch self {
        case .low:       return "Stable returns • 6-8% p.a."
        case .moderate:  return "Balanced growth • Returns 10-14% p.a."
        case .high:      return "High growth • Returns 15-20% p.a."
        }
    }
}

// ─────────────────────────────────────────────
// MARK: — Display Models (for Figma UI)
// ─────────────────────────────────────────────

/// Allocation category shown in pill chips on Home screen
struct AllocationCategory: Identifiable {
    let id = UUID()
    let name: String
    let percentage: Int
    let color: Color
}

/// Investment category card data for Portfolio screen (S2)
struct InvestmentCategory: Identifiable {
    let id = UUID()
    let emoji: String
    let title: String
    let subtitle: String
    let returnPercent: String
    let amount: String
    let barProgress: Double
    let barColor: Color
}

/// Donut chart segment for Portfolio screen (S2)
struct PortfolioSegment: Identifiable {
    let id = UUID()
    let label: String
    let percentage: Double
    let color: Color
}

/// Trending pick for Home (S1) and Trending Picks (S5)
struct TrendingPick: Identifiable {
    let id = UUID()
    let emoji: String
    let name: String
    let subtitle: String
    let returnPercent: String
    let minAmount: String
    let badge: String
    let badgeColor: Color
    var isAdded: Bool
    var cardColor: Color = .primaryPurple
    var iconImage: String? = nil
}

/// Goal item for Goals screen (S3)
struct GoalItem: Identifiable {
    let id = UUID()
    let emoji: String
    let title: String
    let currentAmount: String
    let targetAmount: String
    let progress: Double
    let percentage: Int
    let timeline: String
    let barColor: Color
}

/// Milestone item for Future Plans (S4)
struct MilestoneData: Identifiable {
    let id = UUID()
    let year: String
    let title: String
    let isCompleted: Bool
}

// ─────────────────────────────────────────────
// MARK: — App State
// ─────────────────────────────────────────────

/// Root state container
struct AppState: Codable {
    var userName: String = ""
    var monthlySalary: Double = 0
    var savePercent: Double = 30
    var riskLevel: String = "Moderate"
    var isOnboardingComplete: Bool = false

    var investableAmount: Double {
        monthlySalary * savePercent / 100
    }
}

// ─────────────────────────────────────────────
// MARK: — Profile Store (Persistence)
// ─────────────────────────────────────────────

@Observable
final class ProfileStore {
    var state: AppState = AppState()

    @ObservationIgnored private let key = "wealthwise.appstate.v1"
    @ObservationIgnored private let encoder = JSONEncoder()
    @ObservationIgnored private let decoder = JSONDecoder()

    init() { load() }

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

    func completeOnboarding(name: String, salary: Double, savePercent: Double, risk: String) {
        state.userName = name
        state.monthlySalary = salary
        state.savePercent = savePercent
        state.riskLevel = risk
        state.isOnboardingComplete = true
        save()
    }

    func reset() {
        state = AppState()
        UserDefaults.standard.removeObject(forKey: key)
    }
}

// ─────────────────────────────────────────────
// MARK: — Sample Data (matches Figma exactly)
// ─────────────────────────────────────────────

enum SampleData {

    // MARK: — S1 Home: Allocation Chips
    static let allocations: [AllocationCategory] = [
        AllocationCategory(name: "SIP", percentage: 35, color: .accentGreen),
        AllocationCategory(name: "FD", percentage: 20, color: .accentBlue),
        AllocationCategory(name: "Gold", percentage: 15, color: .accentOrange),
        AllocationCategory(name: "Bonds", percentage: 15, color: .primaryPurple),
        AllocationCategory(name: "MF", percentage: 15, color: .accentGreen),
    ]

    // MARK: — S1 Home: Trending
    static let trendingHome: [TrendingPick] = [
        TrendingPick(
            emoji: "📊", name: "Mirae Asset Large Cap", subtitle: "Mutual Fund",
            returnPercent: "14.2%", minAmount: "₹500/mo",
            badge: "TRENDING", badgeColor: .primaryPurple, isAdded: true,
            cardColor: .trendCoral, iconImage: "mirae_growth"
        ),
        TrendingPick(
            emoji: "🏆", name: "SGB Gold Bond 2025", subtitle: "Sovereign Gold",
            returnPercent: "11.8%", minAmount: "₹2,000 min",
            badge: "LOW RISK", badgeColor: .accentOrange, isAdded: false,
            cardColor: .trendLavender
        ),
        TrendingPick(
            emoji: "🏦", name: "HDFC FD 500 Days", subtitle: "Fixed Deposit",
            returnPercent: "7.5%", minAmount: "₹10,000 min",
            badge: "SAFE", badgeColor: .accentGreen, isAdded: false,
            cardColor: .trendRose
        ),
    ]

    // MARK: — S1 Home: Goal Mini-cards
    static let goalMiniCards: [(emoji: String, label: String, progress: Double)] = [
        ("🏠", "Home", 0.45),
        ("🎓", "Child Ed", 0.22),
        ("✈️", "Travel", 0.67),
    ]

    // MARK: — S2 Portfolio: Donut Segments
    static let portfolioSegments: [PortfolioSegment] = [
        PortfolioSegment(label: "SIP / MF", percentage: 35, color: .primaryPurple),
        PortfolioSegment(label: "FD", percentage: 20, color: .accentGreen),
        PortfolioSegment(label: "Gold", percentage: 15, color: .accentOrange),
        PortfolioSegment(label: "Bonds", percentage: 15, color: .accentBlue),
        PortfolioSegment(label: "Silver", percentage: 10, color: .accentRed),
        PortfolioSegment(label: "Crypto", percentage: 5, color: .accentPink),
    ]

    // MARK: — S2 Portfolio: Investment Categories
    static let investmentCategories: [InvestmentCategory] = [
        InvestmentCategory(emoji: "📊", title: "SIP", subtitle: "5 Active SIPs",
                           returnPercent: "+14.2%", amount: "₹8,925", barProgress: 0.55, barColor: .accentBlue),
        InvestmentCategory(emoji: "🏦", title: "Fixed Deposit", subtitle: "3 FDs Active",
                           returnPercent: "+7.5%", amount: "₹5,100", barProgress: 0.40, barColor: .accentGreen),
        InvestmentCategory(emoji: "🏆", title: "Gold", subtitle: "SGB + ETF",
                           returnPercent: "+11.8%", amount: "₹3,825", barProgress: 0.35, barColor: .accentOrange),
        InvestmentCategory(emoji: "📜", title: "Bonds", subtitle: "Govt + Corp",
                           returnPercent: "+8.2%", amount: "₹3,825", barProgress: 0.30, barColor: .accentBlue),
        InvestmentCategory(emoji: "🪙", title: "Silver", subtitle: "ETF via Zerodha",
                           returnPercent: "+9.1%", amount: "₹2,550", barProgress: 0.20, barColor: .accentRed),
        InvestmentCategory(emoji: "₿", title: "Crypto", subtitle: "BTC + ETH",
                           returnPercent: "+22.4%", amount: "₹1,275", barProgress: 0.12, barColor: .accentBlue),
    ]

    // MARK: — S3 Goals
    static let goals: [GoalItem] = [
        GoalItem(emoji: "🏠", title: "Buy Home",
                 currentAmount: "₹22,50,000", targetAmount: "₹50,00,000",
                 progress: 0.45, percentage: 45, timeline: "~4 yrs left", barColor: .accentBlue),
        GoalItem(emoji: "📚", title: "Child's Education",
                 currentAmount: "₹3,30,000", targetAmount: "₹15,00,000",
                 progress: 0.22, percentage: 22, timeline: "~7 yrs left", barColor: .accentBlue),
        GoalItem(emoji: "✈️", title: "World Tour",
                 currentAmount: "₹2,01,000", targetAmount: "₹3,00,000",
                 progress: 0.67, percentage: 67, timeline: "~8 months", barColor: .accentGreen),
        GoalItem(emoji: "🚗", title: "Car Upgrade",
                 currentAmount: "₹80,000", targetAmount: "₹8,00,000",
                 progress: 0.10, percentage: 10, timeline: "~3 yrs left", barColor: .accentOrange),
    ]

    // MARK: — S4 Future Plans: Milestones
    static let milestones: [MilestoneData] = [
        MilestoneData(year: "2027", title: "Emergency Fund Complete", isCompleted: true),
        MilestoneData(year: "2028", title: "₹10L Corpus Target", isCompleted: false),
        MilestoneData(year: "2030", title: "Home Down Payment Ready", isCompleted: false),
        MilestoneData(year: "2033", title: "Child Education Fund", isCompleted: false),
        MilestoneData(year: "2036", title: "Retirement Starter Pack", isCompleted: false),
    ]

    // MARK: — S4 Future Plans: Bar Chart
    static let projectedBars: [MiniBarChart.Bar] = [
        .init(label: "Y2", value: 0.15),
        .init(label: "Y4", value: 0.30),
        .init(label: "Y6", value: 0.48),
        .init(label: "Y8", value: 0.65),
        .init(label: "Y10", value: 0.82),
        .init(label: "Y12", value: 1.0),
    ]

    // MARK: — S5 Trending Picks: Full Cards
    static let trendingPicks: [TrendingPick] = [
        TrendingPick(
            emoji: "📊", name: "Mirae Asset Large Cap Fund",
            subtitle: "5★ • Equity – Large Cap",
            returnPercent: "14.2% CAGR", minAmount: "₹500/mo",
            badge: "TRENDING", badgeColor: .primaryPurple, isAdded: true
        ),
        TrendingPick(
            emoji: "🏆", name: "SGB Gold Bond 2026",
            subtitle: "Sovereign Backed • 2.5% + Gold",
            returnPercent: "11.8% CAGR", minAmount: "₹2,000 min",
            badge: "LOW RISK", badgeColor: .accentOrange, isAdded: false
        ),
        TrendingPick(
            emoji: "🏦", name: "HDFC Bank FD — 500 Days",
            subtitle: "Secured • DICGC Insured",
            returnPercent: "7.5% p.a.", minAmount: "₹10,000 min",
            badge: "SAFE", badgeColor: .accentGreen, isAdded: false
        ),
    ]
}
