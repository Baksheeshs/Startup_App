import SwiftUI

/// Main tab container using native SwiftUI TabView for proper glass/blur effect,
/// correct safe area handling, and no scroll-behind on the tab bar.
struct MainTabView: View {

    @State private var selectedTab: AppTab = .home
    @State private var showTrending = false

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(onTrendingSeeAll: { showTrending = true })
                .tabItem {
                    Label(AppTab.home.rawValue, systemImage: AppTab.home.icon)
                }
                .tag(AppTab.home)

            PortfolioView()
                .tabItem {
                    Label(AppTab.portfolio.rawValue, systemImage: AppTab.portfolio.icon)
                }
                .tag(AppTab.portfolio)

            GoalsView()
                .tabItem {
                    Label(AppTab.goals.rawValue, systemImage: AppTab.goals.icon)
                }
                .tag(AppTab.goals)

            PlansView()
                .tabItem {
                    Label(AppTab.plans.rawValue, systemImage: AppTab.plans.icon)
                }
                .tag(AppTab.plans)

            ProfileView()
                .tabItem {
                    Label(AppTab.profile.rawValue, systemImage: AppTab.profile.icon)
                }
                .tag(AppTab.profile)
        }
        .tint(Color.primaryPurple)
        .fullScreenCover(isPresented: $showTrending) {
            TrendingPicksView(onApply: { showTrending = false })
        }
    }
}

/// Shared tab definition used by the native TabView.
enum AppTab: String, CaseIterable {
    case home = "Home"
    case portfolio = "Portfolio"
    case goals = "Goals"
    case plans = "Plans"
    case profile = "Profile"

    var icon: String {
        switch self {
        case .home:      return "house.fill"
        case .portfolio: return "chart.bar.fill"
        case .goals:     return "target"
        case .plans:     return "calendar"
        case .profile:   return "person.fill"
        }
    }
}

#Preview {
    MainTabView()
        .environment(ProfileStore())
}
