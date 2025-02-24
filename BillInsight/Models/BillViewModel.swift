import Foundation

class BillViewModel: ObservableObject {
    @Published var bills: [Bill] = Bill.loadAll()
    
    // 计算总收入
    var totalIncome: Double {
        bills.filter { $0.transactionType == .income }
             .reduce(0) { $0 + $1.amount }
    }
    
    // 计算总支出
    var totalExpense: Double {
        bills.filter { $0.transactionType == .expense }
             .reduce(0) { $0 + $1.amount }
    }
    
    // 计算结余
    var balance: Double {
        totalIncome - totalExpense
    }
    
    // 添加新账单时需要指定类型
    func addNewBill(amount: Double, merchant: String, date: Date, type: Bill.TransactionType) {
        let newBill = Bill(
            id: UUID(),
            amount: amount,
            merchant: merchant,
            date: date,
            category: "未分类",
            transactionType: type
        )
        
        bills.append(newBill)
        Bill.saveAll(bills)
    }
} 