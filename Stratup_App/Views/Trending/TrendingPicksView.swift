import SwiftUI

/// S5 — Trending Picks Screen
/// Risk level filter, top 3 fund cards with badges, AI says card, and CTA.
struct TrendingPicksView: View {

    @State private var riskFilter: String = "Moderate"
    @State private var picks: [TrendingPick] = SampleData.trendingPicks
    var onApply: () -> Void = {}

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: AppSpacing.xxLarge) {
                // Header
                header

                // Risk Level Filter
                riskFilterSection

                // Top 3 List
                top3Section

                // AI Says
                AISuggestionCard(
                    variant: .lavender,
                    title: "AI says:",
                    message: "For your ₹25,500 investable amount at Moderate risk, allocate 35% to SIP + 15% Gold as a hedge."
                )

                // CTA
                PrimaryCTAButton(title: "Apply Recommendations") {
                    onApply()
                }

                Spacer().frame(height: 20)
            }
            .padding(.horizontal, AppSpacing.xLarge)
        }
        .background(Color.appBackground.ignoresSafeArea())
    }

    // MARK: — Header

    private var header: some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.textPrimary)
                Text("Trending Picks")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Color.textPrimary)
            }
            Spacer()
        }
        .padding(.top, 8)
    }

    // MARK: — Risk Level Filter

    private var riskFilterSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Risk Level")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(Color.textPrimary)

            RiskLevelPicker(selection: $riskFilter, style: .segmented)
        }
    }

    // MARK: — Top 3 Cards

    private var top3Section: some View {
        VStack(spacing: 12) {
            SectionHeader(emoji: "🔥", title: "Top 3 for \(riskFilter) Risk")

            ForEach(Array(picks.enumerated()), id: \.element.id) { index, pick in
                fundCard(rank: index + 1, pick: pick)
            }
        }
    }

    @ViewBuilder
    private func fundCard(rank: Int, pick: TrendingPick) -> some View {
        HStack(spacing: 12) {
            // Rank circle
            ZStack {
                Circle()
                    .fill(Color.primaryPurple)
                    .frame(width: 28, height: 28)
                Text("\(rank)")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(.white)
            }

            // Emoji icon
            ZStack {
                Circle()
                    .fill(Color.appBackground)
                    .frame(width: 44, height: 44)
                Text(pick.emoji)
                    .font(.system(size: 20))
            }

            // Fund details
            VStack(alignment: .leading, spacing: 4) {
                Text(pick.name)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(Color.textPrimary)
                    .lineLimit(1)

                Text(pick.subtitle)
                    .font(.system(size: 12))
                    .foregroundStyle(Color.textSecondary)

                BadgeTag(text: pick.badge, color: pick.badgeColor)

                // Add / Added button
                if pick.isAdded {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark")
                            .font(.system(size: 11, weight: .bold))
                        Text("Added")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .foregroundStyle(Color.accentGreen)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 50)
                            .fill(Color.accentGreen.opacity(0.1))
                    )
                } else {
                    Button(action: {}) {
                        HStack(spacing: 4) {
                            Text("+")
                                .font(.system(size: 13, weight: .bold))
                            Text("Add")
                                .font(.system(size: 12, weight: .semibold))
                        }
                        .foregroundStyle(Color.primaryPurple)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(Color.primaryPurple, lineWidth: 1.5)
                        )
                    }
                }
            }

            Spacer()

            // Return + Min amount
            VStack(alignment: .trailing, spacing: 4) {
                Text(pick.returnPercent)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Color.textGreen)

                Text(pick.minAmount)
                    .font(.system(size: 12))
                    .foregroundStyle(Color.textSecondary)
            }
        }
        .padding(AppSpacing.large)
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    pick.isAdded
                        ? Color.primaryPurple.opacity(0.5)
                        : Color.clear,
                    style: StrokeStyle(lineWidth: 2, dash: pick.isAdded ? [6, 4] : [])
                )
        )
        .cardShadow()
    }
}

#Preview {
    TrendingPicksView()
}
