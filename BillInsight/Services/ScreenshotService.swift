import UIKit

class ScreenshotService {
    func takeScreenshot() -> UIImage? {
        // 使用系统截图功能
        let screen = UIScreen.main.snapshotView(afterScreenUpdates: true)
        UIGraphicsBeginImageContextWithOptions(screen.bounds.size, false, 0)
        screen.drawHierarchy(in: screen.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
} 