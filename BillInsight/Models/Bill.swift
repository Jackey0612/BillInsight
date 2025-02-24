import Foundation
import SwiftUI

struct Bill: Identifiable, Codable {
    let id: UUID
    var amount: Double
    var merchant: String
    var date: Date
    var category: String
    var transactionType: TransactionType
    var notes: String?
    var imageUrl: String?
    
    // 定义交易类型枚举
    enum TransactionType: String, Codable {
        case income = "income"      // 收入
        case expense = "expense"    // 支出
        
        var displayName: String {
            switch self {
            case .income: return "收入"
            case .expense: return "支出"
            }
        }
        
        var color: Color {
            switch self {
            case .income: return .green   // 收入用绿色表示
            case .expense: return .red    // 支出用红色表示
            }
        }
    }
    
    // 计算实际金额（收入为正，支出为负）
    var actualAmount: Double {
        switch transactionType {
        case .income: return amount
        case .expense: return -amount
        }
    }
    
    // 使用UserDefaults存储，比CoreData更简单
    static func saveAll(_ bills: [Bill]) {
        if let encoded = try? JSONEncoder().encode(bills) {
            UserDefaults.standard.set(encoded, forKey: "bills")
        }
    }
    
    static func loadAll() -> [Bill] {
        if let data = UserDefaults.standard.data(forKey: "bills"),
           let bills = try? JSONDecoder().decode([Bill].self, from: data) {
            return bills
        }
        return []
    }
} 