import SwiftUI

/// 3-option segmented pill selector: Low / Moderate / High.
/// Used on S5 (Trending Picks risk filter) and S6 (Onboarding risk appetite).
struct RiskLevelPicker: View {

    enum Style {
        case segmented    // S5: purple active bg, grey inactive bg
        case pill         // S6: colored dots, orange selected border
    }

    @Binding var selection: String
    var style: Style = .segmented

    private let options = ["Low", "Moderate", "High"]
    private let dotColors: [String: Color] = [
        "Low": .accentGreen,
        "Moderate": .accentOrange,
        "High": .accentRed
    ]

    var body: some View {
        HStack(spacing: style == .segmented ? 0 : 12) {
            ForEach(options, id: \.self) { option in
                Button(action: { selection = option }) {
                    Group {
                        switch style {
                        case .segmented:
                            segmentedLabel(option)
                        case .pill:
                            pillLabel(option)
                        }
                    }
                }
            }
        }
    }

    // MARK: — Segmented style (S5)

    @ViewBuilder
    private func segmentedLabel(_ option: String) -> some View {
        Text(option)
            .font(.system(size: 14, weight: .medium))
            .foregroundStyle(selection == option ? .white : Color.textPrimary)
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .background(
                RoundedRectangle(cornerRadius: 50)
                    .fill(selection == option ? Color.primaryPurple : Color.borderLight.opacity(0.5))
            )
    }

    // MARK: — Pill style (S6)

    @ViewBuilder
    private func pillLabel(_ option: String) -> some View {
        let isSelected = selection == option
        let dotColor = dotColors[option] ?? .gray

        HStack(spacing: 6) {
            Circle()
                .fill(dotColor)
                .frame(width: 8, height: 8)
            Text(option)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(isSelected ? dotColor : Color.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 40)
        .background(
            RoundedRectangle(cornerRadius: 50)
                .fill(isSelected ? dotColor.opacity(0.1) : Color.clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 50)
                .stroke(isSelected ? dotColor : Color.borderLight, lineWidth: isSelected ? 2 : 1)
        )
    }
}

#Preview {
    VStack(spacing: 32) {
        VStack(alignment: .leading) {
            Text("Segmented (S5)").font(.caption)
            RiskLevelPicker(selection: .constant("Moderate"), style: .segmented)
        }
        VStack(alignment: .leading) {
            Text("Pill (S6)").font(.caption)
            RiskLevelPicker(selection: .constant("Moderate"), style: .pill)
        }
    }
    .padding()
}
