import SwiftUI

/// AI suggestion card with distinct background colors.
/// Yellow variant (S3 Goals), Lavender variant (S5 Trending).
struct AISuggestionCard: View {

    enum Variant {
        case yellow     // S3: 💡 AI Suggestion — light yellow bg
        case lavender   // S5: 🤖 AI says — light purple bg
    }

    let variant: Variant
    let title: String
    let message: String

    private var backgroundColor: Color {
        switch variant {
        case .yellow:   return .aiCardYellow
        case .lavender: return .aiCardLavender
        }
    }

    private var titleColor: Color {
        switch variant {
        case .yellow:   return .accentGreen
        case .lavender: return .textPurple
        }
    }

    private var emoji: String {
        switch variant {
        case .yellow:   return "💡"
        case .lavender: return "🤖"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Text(emoji)
                    .font(.subheadline)
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(titleColor)
            }

            Text(message)
                .font(.system(size: 13))
                .foregroundStyle(Color.textSecondary)
                .lineSpacing(2)
        }
        .padding(AppSpacing.large)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(backgroundColor)
        )
    }
}

#Preview {
    VStack(spacing: 16) {
        AISuggestionCard(
            variant: .yellow,
            title: "AI Suggestion",
            message: "Increase Home goal SIP by ₹1,000/mo to achieve goal 6 months earlier."
        )
        AISuggestionCard(
            variant: .lavender,
            title: "AI says:",
            message: "For your ₹25,500 investable amount at Moderate risk, allocate 35% to SIP + 15% Gold as a hedge."
        )
    }
    .padding()
    .background(Color.appBackground)
}
