import SwiftUI

/// S6 — Salary Onboarding Screen
/// Single-screen setup: salary input, save % slider, risk appetite picker.
struct SalaryOnboardingView: View {

    @Environment(ProfileStore.self) private var store
    @State private var salaryText: String = "85,000"
    @State private var savePercent: Double = 30
    @State private var riskSelection: String = "Moderate"
    @FocusState private var isSalaryFocused: Bool

    private var salary: Double {
        Double(salaryText.replacingOccurrences(of: ",", with: "")) ?? 0
    }

    private var investable: Double {
        salary * savePercent / 100
    }

    private var formattedInvestable: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "en_IN")
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: investable)) ?? "\(Int(investable))"
    }

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    Spacer().frame(height: 40)

                    // Welcome header
                    welcomeHeader

                    // Form card
                    formCard

                    // CTA Button
                    PrimaryCTAButton(title: "Generate My Plan", useDarkStyle: true) {
                        store.completeOnboarding(
                            name: "Vansh",
                            salary: salary,
                            savePercent: savePercent,
                            risk: riskSelection
                        )
                    }

                    // Privacy footer
                    Text("Your data is private and never shared. 🔒")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.textSecondary)
                        .multilineTextAlignment(.center)

                    Spacer()
                }
                .padding(.horizontal, AppSpacing.xLarge)
            }
        }
        .onTapGesture { isSalaryFocused = false }
    }

    // MARK: — Welcome Header

    private var welcomeHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("👋")
                .font(.system(size: 48))

            Text("Welcome, Vansh!")
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(Color.textPrimary)

            Text("Let's set up your personal investment dashboard in 2 minutes.")
                .font(.system(size: 14))
                .foregroundStyle(Color.textSecondary)
                .lineSpacing(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: — Form Card

    private var formCard: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Monthly Salary
            VStack(alignment: .leading, spacing: 8) {
                Text("Monthly Salary (₹)")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.textSecondary)

                HStack(spacing: 8) {
                    Text("₹")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color.textPurple)

                    TextField("85,000", text: $salaryText)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color.textPurple)
                        .keyboardType(.numberPad)
                        .focused($isSalaryFocused)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.appBackground)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.borderLight, lineWidth: 1)
                )
            }

            // Save % Slider
            VStack(alignment: .leading, spacing: 8) {
                Text("Save % to Invest")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.textSecondary)

                Slider(value: $savePercent, in: 5...80, step: 5)
                    .tint(Color.accentBlue)

                HStack {
                    Text("\(Int(savePercent))%")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(Color.textPurple)

                    Spacer()
                }

                Text("of monthly salary = ₹\(formattedInvestable)")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.textSecondary)
            }

            // Risk Appetite
            VStack(alignment: .leading, spacing: 12) {
                Text("Risk Appetite")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.textSecondary)

                RiskLevelPicker(selection: $riskSelection, style: .pill)
            }
        }
        .wealthWiseCard()
    }
}

#Preview {
    SalaryOnboardingView()
        .environment(ProfileStore())
}
