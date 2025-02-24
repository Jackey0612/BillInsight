import UIKit

class AppLaunchHandler {
    static let shared = AppLaunchHandler()
    
    func handleLaunchFromShortcut(with url: URL) async {
        // 1. 从快捷指令获取截图
        guard let imageData = url.queryItems?["screenshot"]?.data(using: .base64),
              let screenshot = UIImage(data: imageData) else {
            return
        }
        
        // 2. 在App内处理业务逻辑
        await BillProcessingService.shared.processNewBill(with: screenshot)
    }
} 