import SwiftUI

/// Full-width CTA button with gradient or solid purple background.
/// Used on S5 ("Apply Recommendations →") and S6 ("Generate My Plan →").
struct PrimaryCTAButton: View {

    let title: String
    var useDarkStyle: Bool = false   // S6 uses darker purple
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                Image(systemName: "arrow.right")
                    .font(.system(size: 14, weight: .semibold))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(useDarkStyle
                          ? AnyShapeStyle(Color.ctaDarkPurple)
                          : AnyShapeStyle(LinearGradient.ctaGradient))
            )
            .cardShadow()
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        PrimaryCTAButton(title: "Apply Recommendations") {}
        PrimaryCTAButton(title: "Generate My Plan", useDarkStyle: true) {}
    }
    .padding()
    .background(Color.appBackground)
}
