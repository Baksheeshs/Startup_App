import SwiftUI

// ─────────────────────────────────────────────
// MARK: — App Design System
// ─────────────────────────────────────────────
// Inspired by CRED/Groww premium dark aesthetic.
// All colors, gradients, and spacing tokens live here.

extension Color {

    // MARK: — Backgrounds (deep charcoal, not pure black)
    static let appBackground       = Color(red: 0.078, green: 0.082, blue: 0.098)    // #141519
    static let cardBackground      = Color(red: 0.11, green: 0.114, blue: 0.137)     // #1C1D23
    static let cardBackgroundLight = Color(red: 0.145, green: 0.15, blue: 0.176)      // #25262D
    static let elevatedSurface     = Color(red: 0.18, green: 0.184, blue: 0.212)      // #2E2F36

    // MARK: — Accent Purple (Brand)
//    static let accentPurple        = Color(red: 0.498, green: 0.467, blue: 0.867)     // #7F77DD
    static let accentPurpleLight   = Color(red: 0.686, green: 0.663, blue: 0.925)     // #AFA9EC
    static let accentPurpleMuted   = Color(red: 0.498, green: 0.467, blue: 0.867).opacity(0.15)

    // MARK: — Semantic
    static let safetyGreen         = Color(red: 0.114, green: 0.808, blue: 0.533)     // #1DCE88
    static let warningAmber        = Color(red: 0.937, green: 0.624, blue: 0.153)     // #EF9F27
    static let dangerRed           = Color(red: 0.937, green: 0.325, blue: 0.314)     // #EF5350
    static let growTag             = Color(red: 0.114, green: 0.808, blue: 0.533)     // green
    static let safeTag             = Color(red: 0.38, green: 0.58, blue: 0.98)        // blue
    static let avoidTag            = Color(red: 0.937, green: 0.325, blue: 0.314)     // red

    // MARK: — Text
    static let textPrimary         = Color.white
    static let textSecondary       = Color(red: 0.65, green: 0.66, blue: 0.72)        // #A6A8B8
    static let textTertiary        = Color(red: 0.45, green: 0.46, blue: 0.52)        // #737585
    static let textMuted           = Color(red: 0.35, green: 0.36, blue: 0.41)        // #595C69
}

// MARK: — Gradient Presets

extension LinearGradient {
    /// Primary purple gradient for CTAs
    static let accentGradient = LinearGradient(
        colors: [
            Color(red: 0.45, green: 0.38, blue: 0.90),   // deeper purple
            Color(red: 0.55, green: 0.45, blue: 0.95),   // mid purple
            Color(red: 0.498, green: 0.467, blue: 0.867)  // accent purple
        ],
        startPoint: .leading,
        endPoint: .trailing
    )

    /// Subtle card gradient for glass-morphism feel
    static let cardGradient = LinearGradient(
        colors: [
            Color.white.opacity(0.08),
            Color.white.opacity(0.03)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// Glow gradient for icon backgrounds
    static let glowGradient = LinearGradient(
        colors: [
            Color.accentPurple.opacity(0.6),
            Color.accentPurpleLight.opacity(0.3)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: — Spacing Tokens

enum AppSpacing {
    static let micro:  CGFloat = 4
    static let small:  CGFloat = 8
    static let medium: CGFloat = 16
    static let large:  CGFloat = 24
    static let xLarge: CGFloat = 32
    static let xxLarge: CGFloat = 48
}

// MARK: — Glass Card Modifier

struct GlassCard: ViewModifier {
    var cornerRadius: CGFloat = 16

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(LinearGradient.cardGradient)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                    )
            )
    }
}

extension View {
    func glassCard(cornerRadius: CGFloat = 16) -> some View {
        modifier(GlassCard(cornerRadius: cornerRadius))
    }
}
