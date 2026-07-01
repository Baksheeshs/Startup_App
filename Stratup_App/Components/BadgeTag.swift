import SwiftUI

/// Colored pill badge: TRENDING (purple), LOW RISK (orange), SAFE (green).
/// Used on S5 Trending Picks screen.
struct BadgeTag: View {

    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .font(.system(size: 10, weight: .semibold))
            .foregroundStyle(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(color.opacity(0.12))
            )
    }
}

#Preview {
    HStack(spacing: 8) {
        BadgeTag(text: "TRENDING", color: .primaryPurple)
        BadgeTag(text: "LOW RISK", color: .accentOrange)
        BadgeTag(text: "SAFE", color: .accentGreen)
    }
    .padding()
}
