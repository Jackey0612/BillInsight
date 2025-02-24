import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootView = ContentView()
        window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        handleIncomingURL(url)
    }
    
    private func handleIncomingURL(_ url: URL) {
        // 确保URL格式为 billinsight://newbill?amount=100&merchant=商家&date=2024-03-21
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems else { return }
        
        // 提取数据
        guard let amountStr = queryItems.first(where: { $0.name == "amount" })?.value,
              let amount = Double(amountStr),
              let merchant = queryItems.first(where: { $0.name == "merchant" })?.value,
              let dateStr = queryItems.first(where: { $0.name == "date" })?.value,
              let date = DateFormatter.billDate.date(from: dateStr) else {
            return
        }
        
        // 更新ViewModel
        DispatchQueue.main.async {
            if let rootView = self.window?.rootViewController?.view as? ContentView {
                rootView.viewModel.addNewBill(
                    amount: amount,
                    merchant: merchant,
                    date: date
                )
            }
        }
    }
} 