import SwiftUI

struct WelcomeView: View {

    // MARK: — Properties
    @Binding var path: NavigationPath
    @State private var isVisible = false
    @State private var iconPulse = false
    @State private var badgesVisible = false
    @State private var buttonVisible = false

    // MARK: — Body
    var body: some View {
        ZStack {
            backgroundLayer
            contentLayer
        }
        .navigationBarHidden(true)
        .onAppear { runEntryAnimation() }
    }

    // MARK: — Background

    private var backgroundLayer: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            // Subtle radial glow behind icon
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.accentPurple.opacity(0.15),
                            Color.accentPurple.opacity(0.05),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 20,
                        endRadius: 250
                    )
                )
                .frame(width: 500, height: 500)
                .offset(y: -120)
                .blur(radius: 40)
        }
    }

    // MARK: — Content

    private var contentLayer: some View {
        VStack(spacing: 0) {
            Spacer()
            heroSection
            Spacer().frame(height: AppSpacing.xxLarge)
            trustBadgesSection
            Spacer()
            bottomSection
        }
        .padding(.horizontal, AppSpacing.large)
        .padding(.bottom, AppSpacing.medium)
    }

    // MARK: — Hero (Icon + Title + Tagline)

    private var heroSection: some View {
        VStack(spacing: 20) {
            // Animated glowing icon
            ZStack {
                // Outer glow ring
                Circle()
                    .fill(Color.accentPurple.opacity(0.08))
                    .frame(width: 140, height: 140)
                    .scaleEffect(iconPulse ? 1.08 : 1.0)

                // Inner gradient circle
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.accentPurple.opacity(0.25),
                                Color.accentPurple.opacity(0.08)
                            ],
                            center: .center,
                            startRadius: 10,
                            endRadius: 55
                        )
                    )
                    .frame(width: 110, height: 110)

                // Icon
                Image(systemName: "indianrupeesign.arrow.trianglehead.counterclockwise.rotate.90")
                    .font(.system(size: 48, weight: .medium))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.accentPurpleLight, Color.accentPurple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .opacity(isVisible ? 1 : 0)
            .scaleEffect(isVisible ? 1 : 0.7)

            // App name with gradient
            VStack(spacing: 8) {
                HStack(spacing: 0) {
                    Text("Nivesh")
                        .foregroundStyle(Color.textPrimary)
                    Text("Saathi")
                        .foregroundStyle(Color.accentPurpleLight)
                }
                .font(.system(size: 36, weight: .bold, design: .rounded))

                Text("Your personal finance guide. No jargon.")
                    .font(.body)
                    .foregroundStyle(Color.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 20)
        }
    }

    // MARK: — Trust Badges

    private var trustBadgesSection: some View {
        VStack(spacing: 12) {
            trustBadge(
                icon: "lock.shield.fill",
                boldText: "100% on-device.",
                normalText: "Your data never leaves.",
                delay: 0
            )
            trustBadge(
                icon: "text.book.closed.fill",
                boldText: "Educational only.",
                normalText: "Not SEBI advice.",
                delay: 1
            )
            trustBadge(
                icon: "clock.fill",
                boldText: "3 minutes",
                normalText: "to your first plan.",
                delay: 2
            )
        }
    }

    private func trustBadge(icon: String, boldText: String, normalText: String, delay: Int) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.body)
                .foregroundStyle(Color.accentPurpleLight)
                .frame(width: 32, height: 32)
                .background(Color.accentPurple.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 8))

            (Text(boldText)
                .fontWeight(.semibold)
                .foregroundStyle(Color.textPrimary)
            + Text(" ")
            + Text(normalText)
                .foregroundStyle(Color.textSecondary))
                .font(.subheadline)

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .glassCard(cornerRadius: 14)
        .opacity(badgesVisible ? 1 : 0)
        .offset(x: badgesVisible ? 0 : -30)
        .animation(
            .spring(response: 0.6, dampingFraction: 0.8)
                .delay(Double(delay) * 0.12),
            value: badgesVisible
        )
    }

    // MARK: — Bottom (CTA + Disclaimer)

    private var bottomSection: some View {
        VStack(spacing: 16) {
            // Get Started button
            Button {
                path.append(AppRoute.basicInfo)
            } label: {
                HStack(spacing: 10) {
                    Text("Get Started")
                        .font(.headline)
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    ZStack {
                        // Button gradient
                        LinearGradient.accentGradient
                        // Subtle inner highlight
                        LinearGradient(
                            colors: [Color.white.opacity(0.15), Color.clear],
                            startPoint: .top,
                            endPoint: .center
                        )
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
                // Glow shadow
                .shadow(color: Color.accentPurple.opacity(0.4), radius: 20, y: 8)
            }
            .accessibilityLabel("Get started with NiveshSaathi setup")
            .opacity(buttonVisible ? 1 : 0)
            .offset(y: buttonVisible ? 0 : 20)

            // Disclaimer
            Text("NiveshSaathi is for educational purposes only. It is not SEBI-registered investment advice.")
                .font(.caption2)
                .foregroundStyle(Color.textMuted)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppSpacing.medium)
                .opacity(buttonVisible ? 1 : 0)
        }
    }

    // MARK: — Animation

    private func runEntryAnimation() {
        // Phase 1: Icon + title fade in
        withAnimation(.spring(response: 0.8, dampingFraction: 0.75)) {
            isVisible = true
        }

        // Phase 2: Icon pulse loop
        withAnimation(
            .easeInOut(duration: 2.5)
            .repeatForever(autoreverses: true)
            .delay(0.8)
        ) {
            iconPulse = true
        }

        // Phase 3: Badges slide in
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                badgesVisible = true
            }
        }

        // Phase 4: Button appears
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.85)) {
                buttonVisible = true
            }
        }
    }
}

#Preview {
    NavigationStack {
        WelcomeView(path: .constant(NavigationPath()))
    }
    .environment(ProfileStore())
    .preferredColorScheme(.dark)
}
