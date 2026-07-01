import SwiftUI

/// A thin colored progress bar used across multiple screens.
/// Configurable fill percentage, color, height, and track color.
struct ProgressBar: View {

    let progress: Double        // 0.0 – 1.0
    var barColor: Color = .accentBlue
    var trackColor: Color = Color.borderLight
    var height: CGFloat = 6

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Track
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(trackColor)
                    .frame(height: height)

                // Fill
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(barColor)
                    .frame(
                        width: geometry.size.width * min(max(progress, 0), 1),
                        height: height
                    )
            }
        }
        .frame(height: height)
    }
}

#Preview {
    VStack(spacing: 16) {
        ProgressBar(progress: 0.45, barColor: .accentBlue)
        ProgressBar(progress: 0.67, barColor: .accentGreen)
        ProgressBar(progress: 0.10, barColor: .accentOrange)
        ProgressBar(progress: 0.70, barColor: .accentOrange, trackColor: .accentGreen)
    }
    .padding()
}
