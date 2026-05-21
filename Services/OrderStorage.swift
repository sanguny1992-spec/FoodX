import Foundation

final class OrderStorage {
    
    private let key = "saved_orders"
    
    func save(_ orders: [Order]) {
        
        do {
            
            let data = try JSONEncoder().encode(orders)
            
            UserDefaults.standard.set(
                data,
                forKey: key
            )
            
        } catch {
            
            print(error.localizedDescription)
        }
    }
    
    func load() -> [Order] {
        
        guard let data =
                UserDefaults.standard.data(
                    forKey: key
                )
        else {
            return []
        }
        
        do {
            
            return try JSONDecoder().decode(
                [Order].self,
                from: data
            )
            
        } catch {
            
            print(error.localizedDescription)
            return []
        }
    }
}
