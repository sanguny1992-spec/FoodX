import SwiftUI

struct SemiRow: View {
    
    @ObservedObject var store: InventoryStore
    var semi: SemiFinishedProduct
    
    @State private var showTTK = false
    @State private var ingName = ""
    @State private var ingGrams = ""
    @State private var editingIngredientID: UUID?
    
    @State private var showMenuSheet = false
    @State private var isEditing = false
    
    // ✅ локальные состояния (фикс бага)
    @State private var gramsText = ""
    @State private var nameText = ""
    
    // ✅ для редактирования ингредиента
    @State private var ingEditText = ""
    @State private var ingEditName = ""
    
    var body: some View {
        
        if let i = store.semiProducts.firstIndex(where: { $0.id == semi.id }) {
            
            let item = store.semiProducts[i]
            
            VStack(alignment: .leading, spacing: 12) {
                
                // ✏️ РЕДАКТИРОВАНИЕ ПФ
                if isEditing {
                    
                    TextField("Название", text: $nameText)
                        .textFieldStyle(.roundedBorder)
                        .onChange(of: nameText) { newValue in
                            store.semiProducts[i].name = newValue
                        }
                    
                    TextField("Граммы", text: $gramsText)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.decimalPad)
                        .onChange(of: gramsText) { newValue in
                            let cleaned = newValue.replacingOccurrences(of: ",", with: ".")
                            
                            if let val = Double(cleaned) {
                                store.semiProducts[i].outputQuantityInGrams = val
                            } else if cleaned.isEmpty {
                                store.semiProducts[i].outputQuantityInGrams = 0
                            }
                        }
                    
                    Button("Готово") {

                        print("✅ Нажали Готово")

                        store.save()

                        isEditing = false
                    }
                    .foregroundColor(.green)
                    
                } else {
                    
                    Text(item.name)
                        .font(.headline)
                        .foregroundColor(canProduce(item: item) ? .white : .red)
                    
                    Text("\(Int(item.outputQuantityInGrams)) г")
                        .foregroundColor(.gray)
                    
                    // 📋 ингредиенты
                    VStack(alignment: .leading, spacing: 6) {
                        
                        ForEach(item.ingredients) { ing in
                            
                            if editingIngredientID == ing.id {
                                
                                HStack {
                                    
                                    TextField("Название", text: $ingEditName)
                                        .textFieldStyle(.roundedBorder)
                                    
                                    TextField("г", text: $ingEditText)
                                        .frame(width: 70)
                                        .textFieldStyle(.roundedBorder)
                                        .keyboardType(.decimalPad)
                                    
                                    Button("OK") {
                                        if let idx = store.semiProducts[i].ingredients.firstIndex(where: { $0.id == ing.id }) {
                                            
                                            store.semiProducts[i].ingredients[idx].name = ingEditName
                                            
                                            let cleaned = ingEditText.replacingOccurrences(of: ",", with: ".")
                                            if let val = Double(cleaned) {
                                                store.semiProducts[i].ingredients[idx].grams = val
                                            } else if cleaned.isEmpty {
                                                store.semiProducts[i].ingredients[idx].grams = 0
                                            }
                                        }
                                        
                                        store.save()
                                        editingIngredientID = nil
                                    }
                                    .foregroundColor(.green)
                                }
                                .onAppear {
                                    ingEditName = ing.name
                                    ingEditText = String(ing.grams)
                                }
                                
                            } else {
                                
                                HStack {
                                    Text(ing.name)
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Text("\(Int(ing.grams)) г")
                                        .foregroundColor(.gray)
                                }
                                .font(.caption)
                                .onTapGesture {
                                    editingIngredientID = ing.id
                                }
                            }
                        }
                    }
                    
                    // ➕ ингредиент
                    HStack(spacing: 8) {
                        
                        TextField("Название", text: $ingName)
                            .textFieldStyle(.roundedBorder)
                        
                        TextField("г", text: $ingGrams)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 60)
                            .keyboardType(.decimalPad)
                        
                        Button("+") {
                            addIngredient(index: i)
                        }
                        .foregroundColor(.orange)
                        .font(.title2)
                    }
                    
                    Button {

                        nameText = item.name

                        gramsText = String(
                            item.outputQuantityInGrams
                        )

                        withAnimation {

                            isEditing.toggle()
                        }

                    } label: {

                        Text(
                            isEditing
                            ? "Закрыть"
                            : "Редактировать"
                        )
                    }
                    .foregroundColor(.blue)
                    
                    HStack {
                        
                        
                        Spacer()
                        
                        Menu {
                            Button("⚙️ Произвести") {
                                produce(index: i)
                            }
                            Button(role: .destructive) {
                                store.semiProducts.remove(at: i)
                                store.save()
                            } label: {
                                Text("🗑 Удалить")
                            }
                            Button("⬅️ На склад") {
                                store.products.append(
                                    Product(
                                        name: item.name,
                                        quantityInGrams: item.outputQuantityInGrams,
                                        pricePerKg: 0
                                    )
                                )
                                
                                store.semiProducts.remove(at: i)
                                store.save()
                            }
                            
                            Button("ТТК / Приготовление") {
                                showTTK = true
                            }
                            
                            Button("📄 PDF выгрузка") {
                                
                                guard let url = TTKPDFExporter.export(semi: item) else { return }
                                
                                DispatchQueue.main.async {
                                    let vc = UIActivityViewController(
                                        activityItems: [url],
                                        applicationActivities: nil
                                    )
                                    
                                    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                       let root = scene.windows.first?.rootViewController {
                                        root.present(vc, animated: true)
                                    }
                                }
                            }
                            
                        } label: {
                            Image(systemName: "ellipsis")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.black.opacity(0.3))
                                .clipShape(Circle())
                        }
                    }
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .onAppear {

                nameText = item.name

                gramsText = String(
                    item.outputQuantityInGrams
                )
            }
           
            
            .sheet(isPresented: $showTTK) {
                
                
                VStack(spacing: 12) {
                    
                    Text("Технология приготовления")
                        .font(.headline)
                    
                    TextEditor(text: Binding(
                        get: { store.semiProducts[i].instruction },
                        set: {
                            store.semiProducts[i].instruction = $0
                            store.save()
                        }
                    ))
                    .frame(height: 300)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.3))
                    )
                    
                    Button("Готово") {
                        showTTK = false
                    }
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding()
                
                
                .sheet(isPresented: $showMenuSheet) {
                    IngredientPickerView(store: store, semi: semi)
                }
            }
        }
        
    }
    
    func addIngredient(index: Int) {
        
        guard let grams = Double(ingGrams.replacingOccurrences(of: ",", with: ".")),
              !ingName.isEmpty else { return }
        
        store.semiProducts[index].ingredients.append(
            Ingredient(name: ingName, grams: grams)
        )
        
        let exists = store.products.contains {
            $0.name.lowercased() == ingName.lowercased()
        }
        
        if !exists {
            store.products.append(
                Product(
                    name: ingName,
                    quantityInGrams: 0,
                    pricePerKg: 0
                )
            )
        }
        
        store.save()
        
        ingName = ""
        ingGrams = ""
    }
    
    func canProduce(item: SemiFinishedProduct) -> Bool {
        
        for ing in item.ingredients {
            
            guard let stockItem = store.products.first(where: {
                $0.name.lowercased() == ing.name.lowercased()
            }) else {
                return false
            }
            
            if stockItem.quantityInGrams < ing.grams {
                return false
            }
        }
        
        return true
    }
    
    func produce(index: Int) {
        
        let item = store.semiProducts[index]
        
        // ❌ если нельзя произвести — стоп
        if !canProduce(item: item) {
            print("Недостаточно ингредиентов")
            return
        }
        
        // ✅ списываем ингредиенты
        for ing in item.ingredients {
            
            if let stockIndex = store.products.firstIndex(where: {
                $0.name.lowercased() == ing.name.lowercased()
            }) {
                
                store.products[stockIndex].quantityInGrams -= ing.grams
            }
        }
        
        // 📦 добавляем готовый продукт
        if let existingIndex = store.products.firstIndex(where: {
            $0.name.lowercased() == item.name.lowercased()
        }) {
            
            store.products[existingIndex].quantityInGrams += item.outputQuantityInGrams
            
        } else {
            
            store.products.append(
                Product(
                    name: item.name,
                    quantityInGrams: item.outputQuantityInGrams,
                    pricePerKg: 0
                )
            )
        }
        
        store.save()
    }
}
