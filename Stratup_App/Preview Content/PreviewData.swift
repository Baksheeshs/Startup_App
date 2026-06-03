import Foundation

/// Static mock data for Xcode Previews.
/// Never used in production — only referenced inside #Preview blocks.
enum PreviewData {

    static let store: ProfileStore = {
        let store = ProfileStore()
        store.state = sampleAppState
        return store
    }()

    static let emptyStore: ProfileStore = {
        ProfileStore()
    }()

    static let sampleUserProfile = UserProfile(
        name: "Baksheesh",
        age: 24,
        city: "Delhi NCR",
        incomeType: .salaried,
        dependants: .none
    )

    static let sampleIncomeData = IncomeData(
        userProfileId: sampleUserProfile.id,
        monthlyIncome: 50_000,
        otherIncome: 0,
        monthlyExpenses: 22_000,
        emiObligations: 0
    )

    static let sampleRiskProfile = RiskProfile(
        userProfileId: sampleUserProfile.id,
        riskLevel: .moderate,
        primaryGoal: .wealthBuilding,
        investmentHorizonYears: 10,
        hasTermInsurance: false,
        hasHealthInsurance: true,
        hasEmergencyFund: false,
        existingEmergencyFund: 30_000
    )

    static let sampleAppState: AppState = {
        var state = AppState()
        state.userProfile = sampleUserProfile
        state.incomeData = sampleIncomeData
        state.riskProfile = sampleRiskProfile
        return state
    }()
}
