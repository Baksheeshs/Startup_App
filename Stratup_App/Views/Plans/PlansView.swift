import SwiftUI

/// S4 — Future Plans & Decision Maker Screen
/// Projected wealth hero card, milestones timeline, and AI decision maker.
struct PlansView: View {

    @State private var selectedOption: Int = 0  // 0 = increase, 1 = hold

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: AppSpacing.xxLarge) {
                // Header
                header

                // Hero: Projected Wealth
                projectedWealthCard

                // Milestones
                milestonesSection

                // AI Decision Maker
                decisionMakerSection

            }
            .padding(.horizontal, AppSpacing.xLarge)
        }
        .background(Color.appBackground.ignoresSafeArea())
    }

    // MARK: — Header

    private var header: some View {
        HStack {
            Text("Future Plans")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(Color.textPrimary)

            Spacer()
        }
        .padding(.top, 8)
    }

    // MARK: — Projected Wealth Hero Card

    private var projectedWealthCard: some View {
        HeroGradientCard {
            VStack(alignment: .leading, spacing: 8) {
                Text("Projected Wealth (10 yrs)")
                    .font(.system(size: 13))
                    .foregroundStyle(.white.opacity(0.8))

                Text("₹1,22,40,000")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(.white)

                Text("at 12% CAGR with ₹25,500/mo SIP")
                    .font(.system(size: 13))
                    .foregroundStyle(.white.opacity(0.7))

                Spacer().frame(height: 8)

                MiniBarChart(bars: SampleData.projectedBars)
            }
        }
    }

    // MARK: — Milestones

    private var milestonesSection: some View {
        VStack(spacing: 12) {
            SectionHeader(emoji: "🏛️", title: "Milestones")

            VStack(spacing: 0) {
                ForEach(Array(SampleData.milestones.enumerated()), id: \.element.id) { index, milestone in
                    MilestoneItem(
                        year: milestone.year,
                        title: milestone.title,
                        isCompleted: milestone.isCompleted,
                        isLast: index == SampleData.milestones.count - 1
                    )
                }
            }
            .background(Color.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .cardShadow()
        }
    }

    // MARK: — AI Decision Maker

    private var decisionMakerSection: some View {
        VStack(spacing: 12) {
            SectionHeader(emoji: "🤖", title: "AI Decision Maker")

            VStack(alignment: .leading, spacing: 12) {
                Text("Should I increase SIP this month?")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color.textPrimary)

                Text("Based on your cash flow, goals, and market conditions, here's my recommendation:")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.textSecondary)
                    .lineSpacing(2)

                DecisionOptionCard(
                    emoji: "✅",
                    title: "Yes — Increase by ₹2,000",
                    subtitle: "Market dip = buying opportunity",
                    isSelected: selectedOption == 0
                ) {
                    selectedOption = 0
                }

                DecisionOptionCard(
                    emoji: "⏸️",
                    title: "Hold — Keep current SIP",
                    subtitle: "If expenses rise this month",
                    isSelected: selectedOption == 1
                ) {
                    selectedOption = 1
                }
            }
            .wealthWiseCard()
        }
    }
}

#Preview {
    PlansView()
}
