import SwiftUI

/// Purple gradient hero card used at the top of S1 (salary), S3 (goals summary), S4 (projected wealth).
/// Accepts a custom content closure for flexible inner layout.
struct HeroGradientCard<Content: View>: View {

    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        content()
            .padding(AppSpacing.xLarge)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient.heroGradient)
            )
            .heroShadow()
    }
}

#Preview {
    HeroGradientCard {
        VStack(alignment: .leading, spacing: 4) {
            Text("Monthly Salary")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.8))
            Text("₹ 85,000")
                .font(.system(size: 36, weight: .bold))
                .foregroundStyle(.white)
        }
    }
    .padding()
    .background(Color.appBackground)
}
