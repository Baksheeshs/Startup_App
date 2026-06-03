import Foundation

/// Navigation routes for the entire app.
/// Used with NavigationStack(path:) for programmatic navigation.
enum AppRoute: Hashable {
    // Onboarding flow
    case basicInfo
    case income
    case riskGoals
    case baselineSummary

    // Post-onboarding
    case advicePlan
    case goalDetail(UUID)  // FinancialGoal ID
}
