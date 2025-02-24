import Foundation

class GeminiAPIService {
    static let shared = GeminiAPIService()
    private let apiKey = "YOUR_API_KEY"
    
    func analyzeImage(_ image: UIImage) async throws -> BillInfo {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw APIError.invalidImage
        }
        
        let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro-vision:generateContent")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        // 构建请求体
        let base64Image = imageData.base64EncodedString()
        let prompt = """
        请从这张截图中提取：
        1. 交易类型（收入/支出）
        2. 金额（数字）
        3. 对方名称
        4. 交易时间（格式：yyyy-MM-dd）
        请只返回JSON格式数据，格式为：
        {
            "type": "income/expense",
            "amount": 数字,
            "merchant": "名称",
            "date": "日期"
        }
        """
        let payload = [
            "contents": [
                [
                    "parts": [
                        ["text": prompt],
                        ["inline_data": [
                            "mime_type": "image/jpeg",
                            "data": base64Image
                        ]]
                    ]
                ]
            ]
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: payload)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        // 解析响应数据
        return try JSONDecoder().decode(BillInfo.self, from: data)
    }
} 