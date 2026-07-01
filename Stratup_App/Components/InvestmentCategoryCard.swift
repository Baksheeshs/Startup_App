import SwiftUI

/// Investment category card with emoji icon, title, subtitle, progress bar, return %, and amount.
/// Used on S2 Portfolio screen.
struct InvestmentCategoryCard: View {

    let emoji: String
    let title: String
    let subtitle: String
    let returnPercent: String
    let amount: String
    let barProgress: Double
    var barColor: Color = .accentBlue

    var body: some View {
        HStack(spacing: 14) {
            // Circular emoji icon
            ZStack {
                Circle()
                    .fill(Color.appBackground)
                    .frame(width: 48, height: 48)
                Text(emoji)
                    .font(.system(size: 22))
            }

            // Center: title + subtitle + bar
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color.textPrimary)

                Text(subtitle)
                    .font(.system(size: 13))
                    .foregroundStyle(Color.textSecondary)

                ProgressBar(progress: barProgress, barColor: barColor, height: 4)
            }

            Spacer()

            // Right: return % + amount
            VStack(alignment: .trailing, spacing: 4) {
                Text(returnPercent)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Color.textGreen)

                Text(amount)
                    .font(.system(size: 14))
                    .foregroundStyle(Color.textSecondary)
            }
        }
        .wealthWiseCard(cornerRadius: 12)
    }
}

#Preview {
    VStack(spacing: 12) {
        InvestmentCategoryCard(
            emoji: "📊",
            title: "SIP",
            subtitle: "5 Active SIPs",
            returnPercent: "+14.2%",
            amount: "₹8,925",
            barProgress: 0.55,
            barColor: .accentBlue
        )
        InvestmentCategoryCard(
            emoji: "🏦",
            title: "Fixed Deposit",
            subtitle: "3 FDs Active",
            returnPercent: "+7.5%",
            amount: "₹5,100",
            barProgress: 0.40,
            barColor: .accentGreen
        )
    }
    .padding()
    .background(Color.appBackground)
}
