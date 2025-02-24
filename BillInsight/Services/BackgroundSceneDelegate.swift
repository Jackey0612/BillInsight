class BackgroundSceneDelegate: UIResponder, UIWindowSceneDelegate {
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let url = connectionOptions.userActivities.first?.webpageURL,
           url.scheme == "billinsight" {
            // 解析操作类型
            let action = url.host ?? ""
            switch action {
            case "screenshot":
                handleScreenshotLaunch(with: url)
            case "voice":
                handleVoiceLaunch()
            default:
                break
            }
        }
    }
    
    private func handleVoiceLaunch() {
        Task {
            if await SpeechRecognitionService.shared.requestAuthorization() {
                await SpeechRecognitionService.shared.startListening { result in
                    switch result {
                    case .success(let billInfo):
                        // 保存账单
                        await MainActor.run {
                            if let viewModel = (UIApplication.shared.windows.first?.rootViewController as? UIHostingController<ContentView>)?.rootView.viewModel {
                                viewModel.addNewBill(
                                    amount: billInfo.amount,
                                    merchant: billInfo.merchant,
                                    date: billInfo.date,
                                    type: billInfo.type
                                )
                            }
                            // 显示成功通知
                            NotificationService.shared.showSuccess("语音记账成功")
                        }
                    case .failure(let error):
                        NotificationService.shared.showError("语音识别失败: \(error.localizedDescription)")
                    }
                    // 完成后退出
                    exit(0)
                }
            }
        }
    }
} 