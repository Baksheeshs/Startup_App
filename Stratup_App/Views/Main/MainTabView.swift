import SwiftUI

/// Main tab container wrapping all 5 screens with the custom BottomNavBar.
/// Manages tab selection and the Trending Picks full-screen overlay.
struct MainTabView: View {

    @State private var selectedTab: BottomNavBar.Tab = .home
    @State private var showTrending = false

    var body: some View {
        ZStack(alignment: .bottom) {
            // Active screen
            Group {
                switch selectedTab {
                case .home:
                    HomeView(onTrendingSeeAll: { showTrending = true })
                case .portfolio:
                    PortfolioView()
                case .goals:
                    GoalsView()
                case .plans:
                    PlansView()
                case .profile:
                    ProfileView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Bottom Navigation Bar
            BottomNavBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(.keyboard)
        .fullScreenCover(isPresented: $showTrending) {
            TrendingPicksView(onApply: { showTrending = false })
        }
    }
}

#Preview {
    MainTabView()
        .environment(ProfileStore())
}
