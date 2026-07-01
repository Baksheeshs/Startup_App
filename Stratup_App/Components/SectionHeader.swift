import SwiftUI

/// Reusable section header row: emoji + title on the left, action link on the right.
/// Used across S1–S5 (e.g., "🔥 Trending for You" + "See all →").
struct SectionHeader: View {

    let emoji: String?
    let title: String
    var actionText: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        HStack {
            HStack(spacing: 6) {
                if let emoji = emoji {
                    Text(emoji)
                        .font(.title3)
                }
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Color.textPrimary)
            }

            Spacer()

            if let actionText = actionText {
                Button(action: { action?() }) {
                    Text(actionText)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color.textPurple)
                }
            }
        }
    }
}

#Preview {
    VStack(spacing: 24) {
        SectionHeader(emoji: "🔥", title: "Trending for You", actionText: "See all →")
        SectionHeader(emoji: "🎯", title: "Goals", actionText: "Manage →")
        SectionHeader(emoji: nil, title: "Risk Profile")
    }
    .padding()
}
