import SwiftUI

/// Profile placeholder screen — 5th tab in the bottom navigation.
/// No Figma design provided, so this is a minimal placeholder.
struct ProfileView: View {

    @Environment(ProfileStore.self) private var store

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: AppSpacing.xxLarge) {
                // Header
                HStack {
                    Text("Profile")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(Color.textPrimary)
                    Spacer()
                }
                .padding(.top, 8)

                // Avatar + Name
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(LinearGradient.heroGradient)
                            .frame(width: 80, height: 80)
                        Text("V")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundStyle(.white)
                    }

                    Text("Vansh")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(Color.textPrimary)

                    Text("Member since June 2026")
                        .font(.system(size: 13))
                        .foregroundStyle(Color.textSecondary)
                }
                .padding(.vertical, AppSpacing.xxLarge)

                // Quick Stats
                HStack(spacing: 16) {
                    statCard(label: "Salary", value: "₹85,000")
                    statCard(label: "Investing", value: "₹25,500")
                    statCard(label: "Risk", value: "Moderate")
                }

                // Settings options
                VStack(spacing: 0) {
                    profileRow(icon: "gearshape.fill", title: "Settings")
                    Divider().padding(.leading, 52)
                    profileRow(icon: "bell.fill", title: "Notifications")
                    Divider().padding(.leading, 52)
                    profileRow(icon: "shield.fill", title: "Privacy")
                    Divider().padding(.leading, 52)
                    profileRow(icon: "questionmark.circle.fill", title: "Help & Support")
                }
                .background(Color.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .cardShadow()

                // Reset button
                Button(action: { store.reset() }) {
                    Text("Reset App Data")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color.accentRed)
                }
                .padding(.top, 8)

                Spacer().frame(height: 80)
            }
            .padding(.horizontal, AppSpacing.xLarge)
        }
        .background(Color.appBackground.ignoresSafeArea())
    }

    private func statCard(label: String, value: String) -> some View {
        VStack(spacing: 6) {
            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Color.textPurple)
            Text(label)
                .font(.system(size: 12))
                .foregroundStyle(Color.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .cardShadow()
    }

    private func profileRow(icon: String, title: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(Color.primaryPurple)
                .frame(width: 32)

            Text(title)
                .font(.system(size: 16))
                .foregroundStyle(Color.textPrimary)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Color.textTertiary)
        }
        .padding(.horizontal, AppSpacing.large)
        .padding(.vertical, 14)
    }
}

#Preview {
    ProfileView()
        .environment(ProfileStore())
}
