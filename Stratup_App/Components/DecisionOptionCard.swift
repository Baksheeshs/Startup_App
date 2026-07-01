import SwiftUI

/// Selectable decision option card with icon + title + subtitle.
/// Selected state: green border + green tint bg. Used on S4 AI Decision Maker.
struct DecisionOptionCard: View {

    let emoji: String
    let title: String
    let subtitle: String
    let isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Text(emoji)
                    .font(.system(size: 18))

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(isSelected ? Color.accentGreen : Color.textPrimary)

                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundStyle(isSelected ? Color.accentGreen : Color.textSecondary)
                }

                Spacer()
            }
            .padding(AppSpacing.large)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.accentGreen.opacity(0.08) : Color.cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.accentGreen : Color.borderLight, lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 12) {
        DecisionOptionCard(
            emoji: "✅",
            title: "Yes — Increase by ₹2,000",
            subtitle: "Market dip = buying opportunity",
            isSelected: true,
            action: {}
        )
        DecisionOptionCard(
            emoji: "⏸️",
            title: "Hold — Keep current SIP",
            subtitle: "If expenses rise this month",
            isSelected: false,
            action: {}
        )
    }
    .padding()
    .background(Color.appBackground)
}
