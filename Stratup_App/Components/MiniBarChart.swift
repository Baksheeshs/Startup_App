import SwiftUI

/// Mini vertical bar chart showing projected wealth growth over years.
/// Used on S4 Future Plans hero card.
struct MiniBarChart: View {

    struct Bar: Identifiable {
        let id = UUID()
        let label: String       // "Y2", "Y4", etc.
        let value: Double       // 0.0 – 1.0 normalized height
    }

    let bars: [Bar]

    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            ForEach(bars) { bar in
                VStack(spacing: 4) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.4))
                        .frame(width: 28, height: max(8, 80 * bar.value))

                    Text(bar.label)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(.white.opacity(0.7))
                }
            }
        }
    }
}

#Preview {
    HeroGradientCard {
        VStack(alignment: .leading, spacing: 12) {
            Text("Projected Wealth (10 yrs)")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.8))
            Text("₹1,22,40,000")
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(.white)

            MiniBarChart(bars: [
                .init(label: "Y2", value: 0.15),
                .init(label: "Y4", value: 0.30),
                .init(label: "Y6", value: 0.48),
                .init(label: "Y8", value: 0.65),
                .init(label: "Y10", value: 0.82),
                .init(label: "Y12", value: 1.0),
            ])
        }
    }
    .padding()
    .background(Color.appBackground)
}
