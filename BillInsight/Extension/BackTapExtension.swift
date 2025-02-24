import Foundation

@available(iOS 14.0, *)
class BackTapExtension: NSObject, NSExtensionRequestHandling {
    func beginRequest(with context: NSExtensionContext) {
        // 处理背部双击事件
        handleBackTap()
    }
} 