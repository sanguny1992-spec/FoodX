import Foundation
import SwiftUI
import Combine


final class SupplierStore: ObservableObject {
    
    @Published var suppliers: [Supplier] = []
    
    private let key = "suppliers_key"
    
    init() {
        load()
    }
    
    // MARK: SAVE
    
    func save() {
        
        do {
            
            let data = try JSONEncoder().encode(
                suppliers
            )
            
            UserDefaults.standard.set(
                data,
                forKey: key
            )
            
        } catch {
            
            print(error.localizedDescription)
        }
    }
    
    // MARK: LOAD
    
    func load() {
        
        guard let data = UserDefaults.standard.data(
            forKey: key
        ) else {
            return
        }
        
        do {
            
            suppliers = try JSONDecoder().decode(
                [Supplier].self,
                from: data
            )
            
        } catch {
            
            print(error.localizedDescription)
        }
    }
    
    // MARK: ADD
    
    func addSupplier(name: String) {
        
        let cleaned = name.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        
        guard !cleaned.isEmpty else {
            return
        }
        
        let exists = suppliers.contains {
            
            $0.name.lowercased()
            ==
            cleaned.lowercased()
        }
        
        guard !exists else {
            return
        }
        
        suppliers.append(
            Supplier(name: cleaned)
        )
        
        save()
    }
}
