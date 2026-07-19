import SwiftUI

/// Trending fund card matching the Figma design:
/// — Large colored card with asymmetric rounded corners (top-right extra large)
/// — Large emoji circle overflowing above the top-left area of the card
/// — White bold fund name + lighter subtitle at the bottom
/// — Green return percentage at bottom-left
struct TrendingFundCard: View {

    let emoji: String
    let name: String
    let subtitle: String
    let returnPercent: String
    var cardColor: Color = .primaryPurple
    var iconImage: String? = nil

    /// Circle diameter and how much it sticks out above the card
    private let circleSize: CGFloat = 64
    private let overlapAmount: CGFloat = 24

    var body: some View {
        VStack(spacing: 0) {
            // Space above the card for the protruding circle
            Color.clear.frame(height: overlapAmount)

            // Card + overlapping circle
            ZStack(alignment: .top) {
                // Colored card body
                cardBody

                // Floating emoji circle — sits on the top edge, left-of-center
                emojiCircle
                    .offset(x: -24, y: -(circleSize / 2))
            }
        }
        .frame(width: 175)
    }

    // MARK: — Card Body

    private var cardBody: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Top spacing to clear the circle overlap
            Spacer()
                .frame(height: circleSize / 2 + 8)

            // Fund name
            Text(name)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.white)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)

            // Subtitle
            Text(subtitle)
                .font(.system(size: 13))
                .foregroundStyle(.white.opacity(0.7))

            Spacer()

            // Return percentage
            HStack(spacing: 3) {
                Text("▲")
                    .font(.system(size: 12))
                Text(returnPercent)
                    .font(.system(size: 17, weight: .bold))
            }
            .foregroundStyle(Color.accentGreen)
        }
        .padding(.horizontal, 18)
        .padding(.bottom, 18)
        .frame(width: 175, height: 210, alignment: .leading)
        .background(
            UnevenRoundedRectangle(
                topLeadingRadius: 24,
                bottomLeadingRadius: 24,
                bottomTrailingRadius: 24,
                topTrailingRadius: 52
            )
            .fill(
                LinearGradient(
                    colors: [cardColor, cardColor.opacity(0.85)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        )
    }

    // MARK: — Emoji Circle (floats above card top edge)

    private var emojiCircle: some View {
        ZStack {
            Circle()
                .fill(.white.opacity(0.22))
                .frame(width: circleSize, height: circleSize)
            Circle()
                .fill(.white.opacity(0.15))
                .frame(width: circleSize - 8, height: circleSize - 8)

            if let imageName = iconImage {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: circleSize - 10, height: circleSize - 10)
                    .clipShape(Circle())
            } else {
                Text(emoji)
                    .font(.system(size: 30))
            }
        }
    }
}

#Preview {
    HStack(spacing: 14) {
        TrendingFundCard(
            emoji: "📊",
            name: "Mirae Asset Large Cap",
            subtitle: "Mutual Fund",
            returnPercent: "14.2%",
            cardColor: .trendCoral,
            iconImage: "mirae_growth"
        )
        TrendingFundCard(
            emoji: "🏆",
            name: "SGB Gold Bond 2025",
            subtitle: "Sovereign Gold",
            returnPercent: "11.8%",
            cardColor: .trendLavender
        )
        TrendingFundCard(
            emoji: "🏦",
            name: "HDFC FD 500 Days",
            subtitle: "Fixed Deposit",
            returnPercent: "7.5%",
            cardColor: .trendRose
        )
    }
    .padding()
    .background(Color.appBackground)
}
