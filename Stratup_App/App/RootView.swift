import SwiftUI

/// Root view: Onboarding → Main App flow.
/// Shows SalaryOnboardingView until setup is complete, then MainTabView.
struct RootView: View {

    @Environment(ProfileStore.self) private var store

    var body: some View {
        Group {
            if store.state.isOnboardingComplete {
                MainTabView()
            } else {
                SalaryOnboardingView()
            }
        }
        .preferredColorScheme(.light)
        .animation(.easeInOut(duration: 0.3), value: store.state.isOnboardingComplete)
    }
}

#Preview {
    RootView()
        .environment(ProfileStore())
}
