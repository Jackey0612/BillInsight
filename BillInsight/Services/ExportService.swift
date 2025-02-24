import Foundation

class ExportService {
    static func exportToCSV(bills: [Bill]) -> String {
        var csv = "日期,金额,商家,类别,备注\n"
        for bill in bills {
            csv += "\(bill.date),\(bill.amount),\(bill.merchant),\(bill.category),\(bill.notes ?? "")\n"
        }
        return csv
    }
} 