import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = BillViewModel()
    
    var body: some View {
        TabView {
            BillListView(viewModel: viewModel)
                .tabItem {
                    Label("账单", systemImage: "list.bullet")
                }
            
            AnalyticsView(viewModel: viewModel)
                .tabItem {
                    Label("分析", systemImage: "chart.bar")
                }
            
            SettingsView()
                .tabItem {
                    Label("设置", systemImage: "gear")
                }
        }
    }
} 