import UIKit

class BackgroundSceneDelegate: UIResponder, UIWindowSceneDelegate {
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // 检查是否是从快捷指令启动
        if let url = connectionOptions.userActivities.first?.webpageURL,
           url.scheme == "billinsight" {
            // 使用无界面模式处理
            handleSilentLaunch(with: url)
        }
    }
    
    private func handleSilentLaunch(with url: URL) {
        Task {
            // 1. 处理账单
            await AppLaunchHandler.shared.handleLaunchFromShortcut(with: url)
            
            // 2. 显示通知而不是启动App界面
            await NotificationService.shared.showProcessingResult()
            
            // 3. 完成后终止App
            exit(0)
        }
    }
} 