import SwiftUI

/// Goal progress card showing emoji, title, amount progress, bar, percentage, and timeline.
/// Used on S3 Goals screen.
struct GoalProgressCard: View {

    let emoji: String
    let title: String
    let currentAmount: String
    let targetAmount: String
    let progress: Double        // 0.0 – 1.0
    let percentage: Int
    let timeline: String
    var barColor: Color = .accentBlue

    var body: some View {
        HStack(spacing: 14) {
            // Emoji icon
            ZStack {
                Circle()
                    .fill(Color.appBackground)
                    .frame(width: 48, height: 48)
                Text(emoji)
                    .font(.system(size: 22))
            }

            // Center content
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color.textPrimary)

                Text("\(currentAmount) of \(targetAmount)")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.textSecondary)

                ProgressBar(progress: progress, barColor: barColor)
            }

            Spacer()

            // Right side
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(percentage)%")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(barColor)

                Text(timeline)
                    .font(.system(size: 12))
                    .foregroundStyle(Color.textSecondary)
            }
        }
        .wealthWiseCard()
    }
}

#Preview {
    VStack(spacing: 12) {
        GoalProgressCard(
            emoji: "🏠",
            title: "Buy Home",
            currentAmount: "₹22,50,000",
            targetAmount: "₹50,00,000",
            progress: 0.45,
            percentage: 45,
            timeline: "~4 yrs left",
            barColor: .accentBlue
        )
        GoalProgressCard(
            emoji: "✈️",
            title: "World Tour",
            currentAmount: "₹2,01,000",
            targetAmount: "₹3,00,000",
            progress: 0.67,
            percentage: 67,
            timeline: "~8 months",
            barColor: .accentGreen
        )
    }
    .padding()
    .background(Color.appBackground)
}
