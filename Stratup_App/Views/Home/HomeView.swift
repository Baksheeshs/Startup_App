import SwiftUI

/// S1 — Home Dashboard Screen
/// Main dashboard with salary card, allocation pills, risk profile, trending, and goals.
struct HomeView: View {

    @Environment(ProfileStore.self) private var store
    var onTrendingSeeAll: () -> Void = {}

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: AppSpacing.xxLarge) {
                // Header
                header

                // Hero: Monthly Salary card
                salaryHeroCard

                // My Allocation
                allocationSection

                // Risk Profile
                riskProfileSection

                // Trending for You
                trendingSection

                // Goals
                goalsSection

            }
            .padding(.horizontal, AppSpacing.xLarge)
        }
        .background(Color.appBackground.ignoresSafeArea())
    }

    // MARK: — Header

    private var header: some View {
        HStack {
            Text("WealthWise")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(Color.textPurple)

            Spacer()

            Image(systemName: "bell.fill")
                .font(.system(size: 20))
                .foregroundStyle(Color.accentOrange)
        }
        .padding(.top, 8)
    }

    // MARK: — Salary Hero Card

    private var salaryHeroCard: some View {
        HeroGradientCard {
            VStack(alignment: .leading, spacing: 4) {
                Text("Monthly Salary")
                    .font(.system(size: 13))
                    .foregroundStyle(.white.opacity(0.8))

                Text("₹ 85,000")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundStyle(.white)

                Spacer().frame(height: 8)

                Text("Investable Amount")
                    .font(.system(size: 13))
                    .foregroundStyle(.white.opacity(0.7))

                HStack(spacing: 8) {
                    Text("₹ 25,500")
                        .font(.system(size: 18, weight: .bold))
                    Text("→")
                        .font(.system(size: 16))
                    Text("30%")
                        .font(.system(size: 18, weight: .bold))
                }
                .foregroundStyle(Color(hex: 0xB8A9F0))

                HStack {
                    Spacer()
                    Text("Edit Salary ✏️")
                        .font(.system(size: 13))
                        .foregroundStyle(.white)
                }
            }
        }
    }

    // MARK: — My Allocation

    private var allocationSection: some View {
        VStack(spacing: 12) {
            SectionHeader(emoji: nil, title: "My Allocation", actionText: "Adjust →")

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(SampleData.allocations) { cat in
                        CategoryPillChip(name: cat.name, percentage: cat.percentage, color: cat.color)
                    }
                }
            }
            .wealthWiseCard()
        }
    }

    // MARK: — Risk Profile

    private var riskProfileSection: some View {
        VStack(spacing: 12) {
            SectionHeader(emoji: nil, title: "Risk Profile")

            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 6) {
                    Text("⚡")
                        .font(.subheadline)
                    Text("Moderate Risk")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color.textOrange)
                }

                Text("Balanced growth • Returns 10-14% p.a.")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.textSecondary)

                ProgressBar(progress: 0.70, barColor: .accentOrange, trackColor: .accentGreen)
            }
            .wealthWiseCard()
        }
    }

    // MARK: — Trending for You

    private var trendingSection: some View {
        VStack(spacing: 12) {
            SectionHeader(
                emoji: "🔥",
                title: "Trending for You",
                actionText: "See all →",
                action: onTrendingSeeAll
            )

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(SampleData.trendingHome) { pick in
                        TrendingFundCard(
                            emoji: pick.emoji,
                            name: pick.name,
                            subtitle: pick.subtitle,
                            returnPercent: pick.returnPercent,
                            cardColor: pick.cardColor
                        )
                    }
                }
            }
        }
    }

    // MARK: — Goals

    private var goalsSection: some View {
        VStack(spacing: 12) {
            SectionHeader(emoji: "🎯", title: "Goals", actionText: "Manage →")

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(SampleData.goalMiniCards, id: \.label) { item in
                        VStack(spacing: 8) {
                            ZStack {
                                Circle()
                                    .fill(Color.appBackground)
                                    .frame(width: 48, height: 48)
                                Text(item.emoji)
                                    .font(.system(size: 22))
                            }

                            Text(item.label)
                                .font(.system(size: 13))
                                .foregroundStyle(Color.textSecondary)

                            ProgressBar(
                                progress: item.progress,
                                barColor: .accentBlue,
                                height: 4
                            )
                            .frame(width: 60)
                        }
                    }
                }
            }
            .wealthWiseCard()
        }
    }
}

#Preview {
    HomeView()
        .environment(ProfileStore())
}
