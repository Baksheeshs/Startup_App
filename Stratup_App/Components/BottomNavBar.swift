import SwiftUI

/// Custom 5-tab bottom navigation bar matching the Figma design.
/// Active: purple icon + purple text + blue underline. Inactive: grey.
struct BottomNavBar: View {

    enum Tab: String, CaseIterable {
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

    @Binding var selectedTab: Tab

    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .opacity(0)

            HStack {
                ForEach(Tab.allCases, id: \.self) { tab in
                    tabButton(for: tab)
                }
            }
            .padding(.horizontal, AppSpacing.medium)
            .padding(.top, 8)
            .padding(.bottom, 4)
            .background(
                Color.cardBackground
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: -2)
            )
        }
    }

    @ViewBuilder
    private func tabButton(for tab: Tab) -> some View {
        let isActive = selectedTab == tab

        Button(action: { selectedTab = tab }) {
            VStack(spacing: 4) {
                Image(systemName: tab.icon)
                    .font(.system(size: 20))
                    .foregroundStyle(isActive ? Color.primaryPurple : Color.navInactive)

                Text(tab.rawValue)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(isActive ? Color.primaryPurple : Color.navInactive)

                // Active indicator bar
                RoundedRectangle(cornerRadius: 2)
                    .fill(isActive ? Color.accentBlue : Color.clear)
                    .frame(width: 24, height: 3)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack {
        Spacer()
        BottomNavBar(selectedTab: .constant(.home))
    }
    .background(Color.appBackground)
}
