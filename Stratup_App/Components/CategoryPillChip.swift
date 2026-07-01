import SwiftUI

/// Colored-border pill chip showing allocation category and percentage.
/// Used on S1 Home screen (e.g., "SIP 35%", "FD 20%").
struct CategoryPillChip: View {

    let name: String
    let percentage: Int
    let color: Color

    var body: some View {
        VStack(spacing: 2) {
            Text(name)
                .font(.system(size: 13, weight: .medium))
            Text("\(percentage)%")
                .font(.system(size: 14, weight: .bold))
        }
        .foregroundStyle(color)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 50)
                .stroke(color, lineWidth: 2)
        )
    }
}

#Preview {
    HStack(spacing: 12) {
        CategoryPillChip(name: "SIP", percentage: 35, color: .accentGreen)
        CategoryPillChip(name: "FD", percentage: 20, color: .accentBlue)
        CategoryPillChip(name: "Gold", percentage: 15, color: .accentOrange)
        CategoryPillChip(name: "Bonds", percentage: 15, color: .primaryPurple)
        CategoryPillChip(name: "MF", percentage: 15, color: .accentGreen)
    }
    .padding()
}
