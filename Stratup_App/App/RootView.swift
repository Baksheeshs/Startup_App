import SwiftUI

/// Root view that decides whether to show onboarding or the main app.
struct RootView: View {

    // MARK: — Properties
    @Environment(ProfileStore.self) private var store
    @State private var path = NavigationPath()

    // MARK: — Body
    var body: some View {
        Group {
            if store.state.isOnboardingComplete {
                mainAppPlaceholder
            } else {
                onboardingFlow
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: — Subviews

    private var onboardingFlow: some View {
        NavigationStack(path: $path) {
            WelcomeView(path: $path)
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .basicInfo:
                        PlaceholderView(title: "About You", step: 2)
                    case .income:
                        PlaceholderView(title: "Your Income", step: 3)
                    case .riskGoals:
                        PlaceholderView(title: "Risk & Goals", step: 4)
                    case .baselineSummary:
                        PlaceholderView(title: "Your Baseline", step: 5)
                    default:
                        EmptyView()
                    }
                }
        }
    }

    private var mainAppPlaceholder: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                VStack(spacing: 24) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(Color.safetyGreen)
                    Text("Onboarding complete!")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.textPrimary)
                    Text("Dashboard coming in Step 8")
                        .font(.subheadline)
                        .foregroundStyle(Color.textSecondary)
                }
            }
            .navigationTitle("NiveshSaathi")
        }
    }
}

// MARK: — Temporary Placeholder

struct PlaceholderView: View {
    let title: String
    let step: Int

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            VStack(spacing: 16) {
                Text("Step \(step) of 5")
                    .font(.caption)
                    .foregroundStyle(Color.textTertiary)
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.textPrimary)
                Text("Coming next...")
                    .font(.body)
                    .foregroundStyle(Color.textSecondary)
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    RootView()
        .environment(ProfileStore())
}
