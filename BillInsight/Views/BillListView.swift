import SwiftUI

struct BillListView: View {
    @ObservedObject var viewModel: BillViewModel
    @State private var isRecording = false
    @State private var showingShareSheet = false
    
    var body: some View {
        List {
            // 收支统计部分
            Section(header: Text("收支统计")) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("总收入")
                            .foregroundColor(.secondary)
                        Text("¥\(viewModel.totalIncome, specifier: "%.2f")")
                            .foregroundColor(.green)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("总支出")
                            .foregroundColor(.secondary)
                        Text("¥\(viewModel.totalExpense, specifier: "%.2f")")
                            .foregroundColor(.red)
                    }
                }
                
                // 余额
                HStack {
                    Text("结余")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("¥\(viewModel.balance, specifier: "%.2f")")
                        .foregroundColor(viewModel.balance >= 0 ? .green : .red)
                }
            }
            
            // 账单列表
            Section(header: Text("账单明细")) {
                ForEach(viewModel.bills) { bill in
                    BillRow(bill: bill)
                }
            }
            
            // 添加语音输入按钮
            Button(action: startVoiceInput) {
                HStack {
                    Image(systemName: isRecording ? "waveform" : "mic.fill")
                    Text(isRecording ? "正在录音..." : "语音记账")
                }
            }
            .foregroundColor(isRecording ? .red : .blue)
            
            // 添加分享按钮
            Button(action: { showingShareSheet = true }) {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                    Text("分享分析报告")
                }
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(activityItems: [viewModel.generateShareText()])
        }
    }
    
    private func startVoiceInput() {
        isRecording.toggle()
        if isRecording {
            Task {
                if await SpeechRecognitionService.shared.requestAuthorization() {
                    SpeechRecognitionService.shared.recognizeSpeech { result in
                        switch result {
                        case .success(let billInfo):
                            viewModel.addNewBill(
                                amount: billInfo.amount,
                                merchant: billInfo.merchant,
                                date: billInfo.date,
                                type: billInfo.type
                            )
                        case .failure(let error):
                            print("语音识别失败: \(error)")
                        }
                        isRecording = false
                    }
                }
            }
        }
    }
}

// 单个账单行视图
struct BillRow: View {
    let bill: Bill
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(bill.merchant)
                    .font(.headline)
                Text(bill.date.formatted())
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(bill.transactionType == .income ? "+" : "-")
                    .foregroundColor(bill.transactionType.color)
                + Text("¥\(bill.amount, specifier: "%.2f")")
                    .foregroundColor(bill.transactionType.color)
                
                Text(bill.category)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

// 分享sheet包装器
struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
} 