import SwiftUI

/// S2 — Portfolio Screen
/// Donut chart with allocation breakdown + investment category cards.
struct PortfolioView: View {

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: AppSpacing.xxLarge) {
                // Header
                header

                // Donut chart
                donutSection

                // Investment Categories
                categoriesSection

            }
            .padding(.horizontal, AppSpacing.xLarge)
        }
        .background(Color.appBackground.ignoresSafeArea())
    }

    // MARK: — Header

    private var header: some View {
        HStack {
            Text("Portfolio")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(Color.textPrimary)

            Spacer()

            Text("June 2026")
                .font(.system(size: 14))
                .foregroundStyle(Color.textSecondary)
        }
        .padding(.top, 8)
    }

    // MARK: — Donut Chart

    private var donutSection: some View {
        DonutChartView(
            segments: SampleData.portfolioSegments.map {
                DonutChartView.Segment(
                    label: $0.label,
                    percentage: $0.percentage,
                    color: $0.color
                )
            },
            centerAmount: "₹25,500",
            centerSubtitle: "Invested"
        )
        .wealthWiseCard()
    }

    // MARK: — Investment Categories

    private var categoriesSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Investment Categories")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Color.textPrimary)
                Spacer()
            }

            ForEach(SampleData.investmentCategories) { cat in
                InvestmentCategoryCard(
                    emoji: cat.emoji,
                    title: cat.title,
                    subtitle: cat.subtitle,
                    returnPercent: cat.returnPercent,
                    amount: cat.amount,
                    barProgress: cat.barProgress,
                    barColor: cat.barColor
                )
            }
        }
    }
}

#Preview {
    PortfolioView()
}
