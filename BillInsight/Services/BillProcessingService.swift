import UIKit
import Vision

class BillProcessingService {
    static let shared = BillProcessingService()
    
    func processNewBill() async {
        do {
            // 1. 捕获截图
            let screenshot = try await ScreenCaptureService.shared.captureScreen()
            
            // 2. 调用Gemini API分析截图
            let billInfo = try await GeminiAPIService.shared.analyzeImage(screenshot)
            
            // 3. 在主线程更新UI
            await MainActor.run {
                // 获取ViewModel并添加新账单
                if let viewModel = (UIApplication.shared.windows.first?.rootViewController as? UIHostingController<ContentView>)?.rootView.viewModel {
                    viewModel.addNewBill(
                        amount: billInfo.amount,
                        merchant: billInfo.merchant,
                        date: billInfo.date
                    )
                }
                
                // 显示成功提示
                NotificationService.shared.showSuccess("成功添加新账单")
            }
        } catch {
            await MainActor.run {
                NotificationService.shared.showError("处理账单失败: \(error.localizedDescription)")
            }
        }
    }
} 