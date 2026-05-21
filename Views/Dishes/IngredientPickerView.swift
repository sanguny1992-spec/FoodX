import SwiftUI

struct IngredientPickerView: View {
    
    @ObservedObject var store: InventoryStore
    var semi: SemiFinishedProduct
    
    @Environment(\.dismiss) var dismiss
    
    @State private var search = ""
    
    
    
    
    var body: some View {
        
        NavigationStack {
            
            List {
                
                // 📦 СКЛАД
                Section("Склад") {
                    ForEach(filteredProducts) { product in
                        
                        Button {
                            add(name: product.name)
                        } label: {
                            
                            HStack {
                                Text(product.name)
                                    .foregroundColor(product.quantityInGrams > 0 ? .white : .red)
                                
                                Spacer()
                                
                                Text("\(Int(product.quantityInGrams)) г")
                                    .foregroundColor(product.quantityInGrams > 0 ? .gray : .red)
                            }
                        }
                    }
                }
                
                // 🧪 ПОЛУФАБРИКАТЫ
                Section("Полуфабрикаты") {
                    ForEach(filteredSemi) { item in
                        
                        Button {
                            add(name: item.name)
                        } label: {
                            
                            HStack {
                                Text(item.name)
                                    .foregroundColor(item.outputQuantityInGrams > 0 ? .white : .red)
                                
                                Spacer()
                                
                                Text("\(Int(item.outputQuantityInGrams)) г")
                                    .foregroundColor(item.outputQuantityInGrams > 0 ? .gray : .red)
                            }
                        }
                    }
                }
            }
            .searchable(text: $search)
            .navigationTitle("Меню ингредиентов")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Готово") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    // 🔍 фильтр
    var filteredProducts: [Product] {
        if search.isEmpty { return store.products }
        return store.products.filter {
            $0.name.lowercased().contains(search.lowercased())
        }
    }
    
    var filteredSemi: [SemiFinishedProduct] {
        if search.isEmpty { return store.semiProducts }
        return store.semiProducts.filter {
            $0.name.lowercased().contains(search.lowercased())
        }
    }
    
    // ➕ добавление
    func add(name: String) {
        
        guard let index = store.semiProducts.firstIndex(where: { $0.id == semi.id }) else { return }
        
        // добавляем в ингредиенты
        let exists = store.semiProducts[index].ingredients.contains {
            $0.name.lowercased() == name.lowercased()
        }
        
        if !exists {
            store.semiProducts[index].ingredients.append(
                Ingredient(name: name, grams: 0)
            )
        }
        
        // если нет на складе → создаём
        let existsInStock = store.products.contains {
            $0.name.lowercased() == name.lowercased()
        }
        
        if !existsInStock {
            store.products.append(
                Product(name: name, quantityInGrams: 0, pricePerKg: 0)
            )
        }
        
        store.save()
    }
}
