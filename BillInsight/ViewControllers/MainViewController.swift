import UIKit

class MainViewController: UIViewController {
    private var bills: [Bill] = []
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(BillCell.self, forCellReuseIdentifier: "BillCell")
        return table
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 30
        return button
    }()
    
    private let screenshotButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 30
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    @objc private func handleScreenshot() {
        // 调用系统截图功能
        let screenshotService = ScreenshotService()
        screenshotService.takeScreenshot { [weak self] image in
            if let image = image {
                self?.processScreenshot(image)
            }
        }
    }
    
    private func processScreenshot(_ image: UIImage) {
        // 这里将调用Gemini API
        GeminiAPIService.shared.analyzeImage(image) { [weak self] result in
            switch result {
            case .success(let billInfo):
                self?.saveBillInfo(billInfo)
            case .failure(let error):
                self?.showError(error)
            }
        }
    }
} 