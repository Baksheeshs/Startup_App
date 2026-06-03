import Foundation

extension Double {
    /// Format as Indian Rupees: "₹50,000"
    var asINR: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "INR"
        formatter.currencySymbol = "₹"
        formatter.maximumFractionDigits = 0
        formatter.locale = Locale(identifier: "en_IN")
        return formatter.string(from: NSNumber(value: self)) ?? "₹\(Int(self))"
    }

    /// Format as Indian Rupees with paise: "₹50,000.50"
    var asINRDetailed: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "INR"
        formatter.currencySymbol = "₹"
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "en_IN")
        return formatter.string(from: NSNumber(value: self)) ?? "₹\(self)"
    }

    /// Format as compact Indian notation: "₹12.5L", "₹1.2Cr"
    var asINRCompact: String {
        if self >= 1_00_00_000 {
            return "₹\(String(format: "%.1f", self / 1_00_00_000))Cr"
        } else if self >= 1_00_000 {
            return "₹\(String(format: "%.1f", self / 1_00_000))L"
        } else if self >= 1_000 {
            return "₹\(String(format: "%.0f", self / 1_000))K"
        } else {
            return "₹\(Int(self))"
        }
    }

    /// Format as percentage: "25%"
    var asPercent: String {
        "\(Int(self * 100))%"
    }
}
