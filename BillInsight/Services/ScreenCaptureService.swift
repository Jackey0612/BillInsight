import UIKit

class ScreenCaptureService {
    static let shared = ScreenCaptureService()
    
    func captureScreen() async throws -> UIImage {
        // 使用系统API进行截图
        let screen = UIScreen.main
        let bounds = screen.bounds
        
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        let screenshot = renderer.image { context in
            // 获取当前窗口的内容
            if let window = UIApplication.shared.windows.first {
                window.drawHierarchy(in: bounds, afterScreenUpdates: true)
            }
        }
        
        return screenshot
    }
} 