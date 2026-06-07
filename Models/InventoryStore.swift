import Foundation
import SwiftUI
import Combine

final class InventoryStore: ObservableObject {
    
    // MARK: DATA
    
    @Published var products: [Product] = []
    
    @Published var semiProducts: [SemiFinishedProduct] = []
    
    @Published var dishes: [Dish] = []
    
    @Published var orders: [Order] = []
    
    @Published var writeOffs: [WriteOffRecord] = []
    
    // MARK: KEYS
    
    private let productsKey = "products_key"
    
    private let semiKey = "semi_products_key"
    
    private let dishesKey = "dishes_key"
    
    private let ordersKey = "orders_key"
    
    private let writeOffsKey = "writeoffs_key"
    
    // MARK: INIT
    
    init() {
        load()
    }
    
    // MARK: SAVE
    func delete(product: Product) {
        products.removeAll { $0.id == product.id }
    }
    func update(product: Product) {
        guard let index = products.firstIndex(where: { $0.id == product.id }) else { return }
        products[index] = product
    }
    func addOrIncrease(product: Product) {

        if let index = products.firstIndex(where: {
            $0.name.lowercased() == product.name.lowercased()
        }) {
            products[index].quantityInGrams += product.quantityInGrams
        } else {
            products.append(product)
        }

        save()
    }
    func save() {
        
        if let encoded = try? JSONEncoder().encode(products) {
            
            UserDefaults.standard.set(
                encoded,
                forKey: productsKey
            )
        }
        
        if let encoded = try? JSONEncoder().encode(semiProducts) {
            
            UserDefaults.standard.set(
                encoded,
                forKey: semiKey
            )
        }
        
        if let encoded = try? JSONEncoder().encode(dishes) {
            
            UserDefaults.standard.set(
                encoded,
                forKey: dishesKey
            )
        }
        
        if let encoded = try? JSONEncoder().encode(orders) {
            
            UserDefaults.standard.set(
                encoded,
                forKey: ordersKey
            )
        }
        
        if let encoded = try? JSONEncoder().encode(writeOffs) {
            
            UserDefaults.standard.set(
                encoded,
                forKey: writeOffsKey
            )
        }
    }
    
    // MARK: LOAD
    
    func load() {
        
        // PRODUCTS
        if let data = UserDefaults.standard.data(
            forKey: productsKey
        ) {
            
            do {
                
                let decoded = try JSONDecoder().decode(
                    [Product].self,
                    from: data
                )
                
                products = decoded
                
            } catch {
                
                print("PRODUCT ERROR:")
                print(error)
            }
        }
        
        // SEMI PRODUCTS
        if let data = UserDefaults.standard.data(
            forKey: semiKey
        ) {
            
            do {
                
                let decoded = try JSONDecoder().decode(
                    [SemiFinishedProduct].self,
                    from: data
                )
                
                semiProducts = decoded
                
            } catch {
                
                print("SEMI ERROR:")
                print(error)
            }
        }
        
        // DISHES
        if let data = UserDefaults.standard.data(
            forKey: dishesKey
        ) {
            
            do {
                
                let decoded = try JSONDecoder().decode(
                    [Dish].self,
                    from: data
                )
                
                dishes = decoded
                
            } catch {
                
                print("DISH ERROR:")
                print(error)
            }
        }
        
        // ORDERS
        if let data = UserDefaults.standard.data(
            forKey: ordersKey
        ) {
            
            do {
                
                let decoded = try JSONDecoder().decode(
                    [Order].self,
                    from: data
                )
                
                orders = decoded
                
            } catch {
                
                print("ORDER ERROR:")
                print(error)
            }
        }
        
        // WRITEOFFS
        if let data = UserDefaults.standard.data(
            forKey: writeOffsKey
        ) {
            
            do {
                
                let decoded = try JSONDecoder().decode(
                    [WriteOffRecord].self,
                    from: data
                )
                
                writeOffs = decoded
                
            } catch {
                
                print("WRITEOFF ERROR:")
                print(error)
            }
        }
    }
    func findProduct(from text: String) -> Product? {

        let lower = text.lowercased()

        return products.first(where: {
            lower.contains($0.name.lowercased())
        })
    }
    func extractGrams(from text: String) -> Double? {

        let pattern = #"(\d+)\s*(кг|kg|г|g)"#

        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return nil
        }

        let range = NSRange(text.startIndex..., in: text)

        guard let match = regex.firstMatch(in: text, range: range),
              let valueRange = Range(match.range(at: 1), in: text) else {
            return nil
        }

        let value = Double(text[valueRange]) ?? 0

        if text.lowercased().contains("кг") || text.lowercased().contains("kg") {
            return value * 1000
        }

        return value
    }
    func writeOff(from message: String, employee: String) {

        guard let product = findProduct(from: message) else {
            print("❌ Продукт не найден")
            return
        }

        guard let grams = extractGrams(from: message) else {
            print("❌ Не удалось понять количество")
            return
        }

        guard let index = products.firstIndex(where: { $0.id == product.id }) else {
            return
        }

        products[index].quantityInGrams -= grams

        if products[index].quantityInGrams < 0 {
            products[index].quantityInGrams = 0
        }

        writeOffs.append(
            WriteOffRecord(
                productName: product.name,
                grams: grams,
                reason: "Списание из чата",
                employee: employee
            )
        )

        save()

        print("✅ Списано \(grams) г \(product.name)")
    }
}
