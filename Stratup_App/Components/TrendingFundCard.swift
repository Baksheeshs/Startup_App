import SwiftUI

/// Small card showing a trending fund — used in S1 horizontal scroll and S5 detailed list.
struct TrendingFundCard: View {

    let emoji: String
    let name: String
    let subtitle: String
    let returnPercent: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Circular emoji icon
            ZStack {
                Circle()
                    .fill(Color.appBackground)
                    .frame(width: 48, height: 48)
                Text(emoji)
                    .font(.system(size: 22))
            }

            Text(name)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(Color.textPrimary)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)

            Text(subtitle)
                .font(.system(size: 12))
                .foregroundStyle(Color.textSecondary)

            HStack(spacing: 2) {
                Text("▲")
                    .font(.system(size: 10))
                Text(returnPercent)
                    .font(.system(size: 12, weight: .bold))
            }
            .foregroundStyle(Color.textGreen)
        }
        .padding(12)
        .frame(width: 140, alignment: .leading)
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .trendingShadow()
    }
}

#Preview {
    HStack(spacing: 12) {
        TrendingFundCard(
            emoji: "📊",
            name: "Mirae Asset Large Cap",
            subtitle: "Mutual Fund",
            returnPercent: "14.2%"
        )
        TrendingFundCard(
            emoji: "🏆",
            name: "SGB Gold Bond 2025",
            subtitle: "Sovereign Gold",
            returnPercent: "11.8%"
        )
    }
    .padding()
    .background(Color.appBackground)
}
