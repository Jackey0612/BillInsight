import UIKit

class BackTapService {
    static let shared = BackTapService()
    private var handler: (() -> Void)?
    
    func startMonitoring(completion: @escaping () -> Void) {
        handler = completion
        
        // 配置后台双击检测
        if let window = UIApplication.shared.windows.first {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackTap))
            tapGesture.numberOfTapsRequired = 2
            window.addGestureRecognizer(tapGesture)
        }
    }
    
    @objc private func handleBackTap() {
        handler?()
    }
    
    func setupSystemWideBackTap() {
        // 注册后台任务
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: "com.billinsight.backtap",
            using: nil
        ) { task in
            self.handleBackgroundTask(task)
        }
    }
} 