import Foundation
import CoreData

class DataStorageService {
    static let shared = DataStorageService()
    
    // 使用CoreData存储数据
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BillInsight")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        return container
    }()
    
    func saveBill(_ bill: Bill) {
        let context = persistentContainer.viewContext
        let billEntity = BillEntity(context: context)
        
        billEntity.id = bill.id
        billEntity.amount = bill.amount
        billEntity.merchant = bill.merchant
        billEntity.date = bill.date
        
        do {
            try context.save()
        } catch {
            print("Failed to save bill: \(error)")
        }
    }
} 