import SwiftUI
import Charts

struct AnalyticsView: View {
    @ObservedObject var viewModel: BillViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 月度支出趋势
                    ChartView(bills: viewModel.bills)
                        .frame(height: 200)
                    
                    // 支出分类统计
                    CategoryPieChart(bills: viewModel.bills)
                    
                    // 消费分析建议
                    SpendingInsightsView(bills: viewModel.bills)
                }
                .padding()
            }
            .navigationTitle("消费分析")
        }
    }
} 