import SwiftUI

/// Segmented donut chart with center label and side legend.
/// Used on S2 Portfolio screen.
struct DonutChartView: View {

    struct Segment: Identifiable {
        let id = UUID()
        let label: String
        let percentage: Double
        let color: Color
    }

    let segments: [Segment]
    let centerAmount: String
    let centerSubtitle: String

    private let lineWidth: CGFloat = 20

    var body: some View {
        HStack(spacing: 24) {
            // Donut ring
            ZStack {
                donutRing
                    .frame(width: 160, height: 160)

                VStack(spacing: 2) {
                    Text(centerAmount)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(Color.textPrimary)
                    Text(centerSubtitle)
                        .font(.system(size: 12))
                        .foregroundStyle(Color.textSecondary)
                }
            }

            // Legend
            VStack(alignment: .leading, spacing: 8) {
                ForEach(segments) { seg in
                    HStack(spacing: 8) {
                        Circle()
                            .fill(seg.color)
                            .frame(width: 8, height: 8)
                        Text(seg.label)
                            .font(.system(size: 13))
                            .foregroundStyle(Color.textSecondary)
                        Spacer()
                        Text("\(Int(seg.percentage))%")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(Color.textPrimary)
                    }
                }
            }
        }
    }

    // MARK: — Donut Ring Drawing

    private var donutRing: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let radius = min(size.width, size.height) / 2 - lineWidth / 2
            let total = segments.reduce(0) { $0 + $1.percentage }
            guard total > 0 else { return }

            var startAngle: Angle = .degrees(-90)

            for segment in segments {
                let sweepAngle: Angle = .degrees(360 * segment.percentage / total)
                let endAngle = startAngle + sweepAngle

                let path = Path { p in
                    p.addArc(
                        center: center,
                        radius: radius,
                        startAngle: startAngle,
                        endAngle: endAngle,
                        clockwise: false
                    )
                }

                context.stroke(
                    path,
                    with: .color(segment.color),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .butt)
                )

                startAngle = endAngle
            }
        }
    }
}

#Preview {
    DonutChartView(
        segments: [
            .init(label: "SIP / MF", percentage: 35, color: .primaryPurple),
            .init(label: "FD", percentage: 20, color: .accentGreen),
            .init(label: "Gold", percentage: 15, color: .accentOrange),
            .init(label: "Bonds", percentage: 15, color: .accentBlue),
            .init(label: "Silver", percentage: 10, color: .accentRed),
            .init(label: "Crypto", percentage: 5, color: .accentPink),
        ],
        centerAmount: "₹25,500",
        centerSubtitle: "Invested"
    )
    .wealthWiseCard()
    .padding()
    .background(Color.appBackground)
}
