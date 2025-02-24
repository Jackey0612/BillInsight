import Speech

class SpeechRecognitionService {
    static let shared = SpeechRecognitionService()
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "zh_CN"))
    private let audioEngine = AVAudioEngine()
    
    func requestAuthorization() async -> Bool {
        await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        }
    }
    
    func startListening(completion: @escaping (Result<BillInfo, Error>) -> Void) async {
        do {
            // 配置音频会话
            let audioSession = AVAudioSession.sharedInstance()
            try await audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try await audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            
            // 开始录音
            let recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            recognitionRequest.taskHint = .dictation
            
            // 配置音频输入
            let inputNode = audioEngine.inputNode
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
                recognitionRequest.append(buffer)
            }
            
            // 启动引擎
            try audioEngine.start()
            
            // 设置超时
            Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { _ in
                self.stopListening()
            }
            
            // 开始识别
            let recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let result = result, result.isFinal {
                    self.parseSpeechResult(result.bestTranscription.formattedString, completion: completion)
                    self.stopListening()
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    private func stopListening() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
    
    private func parseSpeechResult(_ text: String, completion: @escaping (Result<BillInfo, Error>) -> Void) {
        // 使用正则表达式解析语音内容
        let pattern = "(收入|支出)(\\d+)元(给|从)(.+)"
        if let regex = try? NSRegularExpression(pattern: pattern),
           let match = regex.firstMatch(in: text, range: NSRange(text.startIndex..., in: text)) {
            
            let type = (text as NSString).substring(with: match.range(at: 1))
            let amount = Double((text as NSString).substring(with: match.range(at: 2))) ?? 0
            let merchant = (text as NSString).substring(with: match.range(at: 4))
            
            let billInfo = BillInfo(
                type: type == "收入" ? .income : .expense,
                amount: amount,
                merchant: merchant,
                date: Date()
            )
            
            completion(.success(billInfo))
        } else {
            completion(.failure(ParseError.invalidFormat))
        }
    }
} 