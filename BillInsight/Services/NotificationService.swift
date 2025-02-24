import UIKit
import UserNotifications

class NotificationService {
    static let shared = NotificationService()
    
    func showSuccess(_ message: String) {
        showNotification(message: message, type: .success)
    }
    
    func showError(_ message: String) {
        showNotification(message: message, type: .error)
    }
    
    private func showNotification(message: String, type: NotificationType) {
        // 创建一个简单的弹窗通知
        let alert = UIAlertController(
            title: type == .success ? "成功" : "错误",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let viewController = windowScene.windows.first?.rootViewController {
            viewController.present(alert, animated: true)
        }
    }
    
    func showProcessingResult() async {
        let content = UNMutableNotificationContent()
        content.title = "账单已记录"
        content.body = "新的支付记录已成功保存"
        content.sound = .default
        
        // 添加打开App的操作
        content.categoryIdentifier = "BILL_ADDED"
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )
        
        try? await UNUserNotificationCenter.current().add(request)
    }
    
    func setupNotificationCategories() {
        let viewAction = UNNotificationAction(
            identifier: "VIEW_BILL",
            title: "查看详情",
            options: .foreground
        )
        
        let category = UNNotificationCategory(
            identifier: "BILL_ADDED",
            actions: [viewAction],
            intentIdentifiers: [],
            options: .customDismissAction
        )
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
    
    private enum NotificationType {
        case success
        case error
    }
} 