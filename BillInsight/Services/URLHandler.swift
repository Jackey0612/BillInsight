enum URLError: Error {
    case invalidFormat
    case invalidData
    case invalidAmount
    case invalidDate
}

class URLHandler {
    static func validateAndParseURL(_ url: URL) throws -> (Double, String, Date) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems else {
            throw URLError.invalidFormat
        }
        
        // 验证和解析数据
        guard let amountStr = queryItems.first(where: { $0.name == "amount" })?.value,
              let amount = Double(amountStr),
              let merchant = queryItems.first(where: { $0.name == "merchant" })?.value,
              let dateStr = queryItems.first(where: { $0.name == "date" })?.value,
              let date = DateFormatter.billDate.date(from: dateStr) else {
            throw URLError.invalidData
        }
        
        return (amount, merchant, date)
    }
} 