import UIKit
import SwiftUI

class ShareService {
    static let shared = ShareService()
    
    // 分享账单
    func shareBill(_ bill: Bill) -> UIActivityViewController {
        // 生成分享文本
        let shareText = """
        【账单分享】
        类型：\(bill.transactionType.displayName)
        金额：¥\(String(format: "%.2f", bill.amount))
        对象：\(bill.merchant)
        时间：\(bill.date.formatted())
        分类：\(bill.category)
        """
        
        return UIActivityViewController(
            activityItems: [shareText],
            applicationActivities: nil
        )
    }
    
    // 分享分析报告
    func shareAnalysisReport(viewModel: BillViewModel) -> UIActivityViewController {
        // 生成分析报告
        let report = """
        【收支分析报告】
        
        总收入：¥\(String(format: "%.2f", viewModel.totalIncome))
        总支出：¥\(String(format: "%.2f", viewModel.totalExpense))
        结余：¥\(String(format: "%.2f", viewModel.balance))
        
        本月最大支出：\(viewModel.getMaxExpense()?.merchant ?? "无") (¥\(String(format: "%.2f", viewModel.getMaxExpense()?.amount ?? 0)))
        主要支出类别：\(viewModel.getTopExpenseCategories().joined(separator: "、"))
        
        理财建议：
        \(viewModel.getFinancialAdvice())
        """
        
        return UIActivityViewController(
            activityItems: [report],
            applicationActivities: nil
        )
    }
} 