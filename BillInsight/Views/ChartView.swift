import SwiftUI
import Charts

struct ChartView: View {
    let bills: [Bill]
    
    var body: some View {
        Chart(bills) { bill in
            BarMark(
                x: .value("Date", bill.date),
                y: .value("Amount", bill.amount)
            )
        }
        .frame(height: 200)
    }
} 