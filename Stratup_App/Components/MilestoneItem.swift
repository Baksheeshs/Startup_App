import SwiftUI

/// Milestone timeline row: year label (green) + milestone text + status circle/check.
/// Used on S4 Future Plans screen.
struct MilestoneItem: View {

    let year: String
    let title: String
    let isCompleted: Bool
    var isLast: Bool = false

    var body: some View {
        HStack(spacing: 14) {
            // Status indicator
            ZStack {
                if isCompleted {
                    Circle()
                        .fill(Color.accentGreen)
                        .frame(width: 28, height: 28)
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(.white)
                } else {
                    Circle()
                        .stroke(Color.borderLight, lineWidth: 2)
                        .frame(width: 28, height: 28)
                }
            }

            // Year + Milestone text
            VStack(alignment: .leading, spacing: 2) {
                Text(year)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(Color.textGreen)

                Text(title)
                    .font(.system(size: 15))
                    .foregroundStyle(Color.textPrimary)
            }

            Spacer()

            // Completed checkmark on right side
            if isCompleted {
                Image(systemName: "checkmark")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.accentGreen)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, AppSpacing.large)
        .overlay(alignment: .bottom) {
            if !isLast {
                Divider()
                    .padding(.leading, 58)
            }
        }
    }
}

#Preview {
    VStack(spacing: 0) {
        MilestoneItem(year: "2027", title: "Emergency Fund Complete", isCompleted: true)
        MilestoneItem(year: "2028", title: "₹10L Corpus Target", isCompleted: false)
        MilestoneItem(year: "2030", title: "Home Down Payment Ready", isCompleted: false)
        MilestoneItem(year: "2033", title: "Child Education Fund", isCompleted: false)
        MilestoneItem(year: "2036", title: "Retirement Starter Pack", isCompleted: false, isLast: true)
    }
    .background(Color.cardBackground)
    .clipShape(RoundedRectangle(cornerRadius: 16))
    .cardShadow()
    .padding()
    .background(Color.appBackground)
}
