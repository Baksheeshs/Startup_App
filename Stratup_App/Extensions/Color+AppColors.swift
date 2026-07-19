import SwiftUI

// ─────────────────────────────────────────────
// MARK: — WealthWise Design System
// ─────────────────────────────────────────────
// Extracted from Figma: WealthWise – Investment Advisor App
// Light-mode, purple-first brand identity with lavender-grey backgrounds.

extension Color {

    // MARK: — Primary Brand
    static let primaryPurple       = Color(hex: 0x6C3CE1)
    static let primaryPurpleDark   = Color(hex: 0x3A1A8E)
    static let primaryPurpleLight  = Color(hex: 0x5B2ED0)
    static let ctaDarkPurple       = Color(hex: 0x2D1B69)

    // MARK: — Accent Colors
    static let accentOrange        = Color(hex: 0xF59E0B)
    static let accentOrangeDark    = Color(hex: 0xFF8C00)
    static let accentGreen         = Color(hex: 0x10B981)
    static let accentGreenLight    = Color(hex: 0x00C48C)
    static let accentBlue          = Color(hex: 0x3B82F6)
    static let accentBlueSoft      = Color(hex: 0x4F7DF3)
    static let accentRed           = Color(hex: 0xEF4444)
    static let accentRedLight      = Color(hex: 0xF87171)
    static let accentTeal          = Color(hex: 0x06B6D4)
    static let accentPink          = Color(hex: 0xA855F7)
    static let accentMagenta       = Color(hex: 0x9333EA)

    // MARK: — Backgrounds
    static let appBackground       = Color(hex: 0xF8F7FC)
    static let appBackgroundAlt    = Color(hex: 0xF5F3FF)
    static let cardBackground      = Color.white
    static let aiCardYellow        = Color(hex: 0xFEF3C7)
    static let aiCardYellowAlt     = Color(hex: 0xFFF9E6)
    static let aiCardLavender      = Color(hex: 0xEDE9FE)
    static let aiCardLavenderAlt   = Color(hex: 0xF0ECFF)

    // MARK: — Text
    static let textPrimary         = Color(hex: 0x1A1A2E)
    static let textPrimaryAlt      = Color(hex: 0x111827)
    static let textSecondary       = Color(hex: 0x6B7280)
    static let textTertiary        = Color(hex: 0x9CA3AF)
    static let textGreen           = Color(hex: 0x10B981)
    static let textPurple          = Color(hex: 0x6C3CE1)
    static let textOrange          = Color(hex: 0xF59E0B)

    // MARK: — Borders & Dividers
    static let borderLight         = Color(hex: 0xE5E7EB)
    static let borderPurpleLight   = Color(hex: 0xF3F0FF)

    // MARK: — Bottom Nav
    static let navInactive         = Color(hex: 0x9CA3AF)

    // MARK: — Trending Card Backgrounds
    static let trendCoral          = Color(hex: 0xF0968D)
    static let trendLavender       = Color(hex: 0x8B7BCC)
    static let trendRose           = Color(hex: 0xE88BA7)

    // MARK: — Hex Initializer
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0,
            opacity: alpha
        )
    }
}

// MARK: — Gradient Presets

extension LinearGradient {
    /// Hero card purple gradient (left → right) — used on S1, S3, S4
    static let heroGradient = LinearGradient(
        colors: [Color.primaryPurple, Color.primaryPurpleDark],
        startPoint: .leading,
        endPoint: .trailing
    )

    /// CTA button gradient
    static let ctaGradient = LinearGradient(
        colors: [Color.primaryPurple, Color.primaryPurpleLight],
        startPoint: .leading,
        endPoint: .trailing
    )
}

// MARK: — Spacing Tokens

enum AppSpacing {
    static let micro:   CGFloat = 4
    static let small:   CGFloat = 8
    static let medium:  CGFloat = 12
    static let large:   CGFloat = 16
    static let xLarge:  CGFloat = 20
    static let xxLarge: CGFloat = 24
    static let huge:    CGFloat = 32
}

// MARK: — Shadow Presets

struct CardShadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color.black.opacity(0.06), radius: 4, x: 0, y: 2)
    }
}

struct HeroShadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color.primaryPurple.opacity(0.2), radius: 8, x: 0, y: 4)
    }
}

struct TrendingShadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
    }
}

// MARK: — Card Modifier

struct WealthWiseCard: ViewModifier {
    var cornerRadius: CGFloat = 16
    var padding: CGFloat = AppSpacing.large

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(Color.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .modifier(CardShadow())
    }
}

extension View {
    func wealthWiseCard(cornerRadius: CGFloat = 16, padding: CGFloat = AppSpacing.large) -> some View {
        modifier(WealthWiseCard(cornerRadius: cornerRadius, padding: padding))
    }

    func cardShadow() -> some View {
        modifier(CardShadow())
    }

    func heroShadow() -> some View {
        modifier(HeroShadow())
    }

    func trendingShadow() -> some View {
        modifier(TrendingShadow())
    }
}
