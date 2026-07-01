import SwiftUI

/// S3 — Goals Screen
/// Hero goals summary, goal progress cards, and AI suggestion.
struct GoalsView: View {

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: AppSpacing.xxLarge) {
                // Header
                header

                // Hero: Goals Summary
                goalsSummaryCard

                // Goal Cards
                goalCardsSection

                // AI Suggestion
                AISuggestionCard(
                    variant: .yellow,
                    title: "AI Suggestion",
                    message: "Increase Home goal SIP by ₹1,000/mo to achieve goal 6 months earlier."
                )

                Spacer().frame(height: 80) // Space for bottom nav
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
                Text("My Goals")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Color.textPrimary)
            }

            Spacer()

            Text("+ Add")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Color.textPurple)
        }
        .padding(.top, 8)
    }

    // MARK: — Goals Summary Hero Card

    private var goalsSummaryCard: some View {
        HeroGradientCard {
            VStack(alignment: .leading, spacing: 4) {
                Text("3 Active Goals")
                    .font(.system(size: 13))
                    .foregroundStyle(.white.opacity(0.8))

                Text("₹12,750 / mo saving")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(.white)

                Text("On track to reach 2 goals by 2028 🚀")
                    .font(.system(size: 13))
                    .foregroundStyle(.white.opacity(0.8))
            }
        }
    }

    // MARK: — Goal Cards

    private var goalCardsSection: some View {
        VStack(spacing: 12) {
            ForEach(SampleData.goals) { goal in
                GoalProgressCard(
                    emoji: goal.emoji,
                    title: goal.title,
                    currentAmount: goal.currentAmount,
                    targetAmount: goal.targetAmount,
                    progress: goal.progress,
                    percentage: goal.percentage,
                    timeline: goal.timeline,
                    barColor: goal.barColor
                )
            }
        }
    }
}

#Preview {
    GoalsView()
}
