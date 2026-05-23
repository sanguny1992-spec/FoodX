import SwiftUI
import FirebaseFirestore

struct ContentView: View {
    
    struct ExportData: Codable {
        var products: [Product]
        var semiProducts: [SemiFinishedProduct]
    }
    
    @StateObject var store = InventoryStore()
    
    @State private var showMenu = false
    @State private var showSchedule = false
    
    @State private var searchText = ""
    
    @State private var name = ""
    @State private var qty = ""
    @State private var price = ""
    
    @State private var type: AddTarget = .stock
    
    @FocusState private var focusedField: Field?
    
    enum Field {
        case name, qty, price
    }
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                // BACKGROUND
                
                Image("FoodX")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                Color.black.opacity(0.55)
                    .ignoresSafeArea()
                
                // 🔥 ГЛАВНЫЙ SCROLL
                
                ScrollView(showsIndicators: false) {
                    
                    VStack(spacing: 0) {
                        
                        // TOP PANEL
                        
                        VStack(spacing: 10) {
                            
                            HStack {
                                
                                Capsule()
                                    .fill(Color.white.opacity(0.25))
                                    .frame(width: 45, height: 5)
                                
                                Spacer()
                                
                                NavigationLink {
                                    
                                    SuppliersView()
                                    
                                } label: {
                                    
                                    Image(systemName: "truck.box.fill")
                                        .font(.title2)
                                        .foregroundColor(.cyan)
                                }
                                
                                // 🛒 ЗАКАЗЫ
                                
                                NavigationLink {
                                    
                                    CreateOrderView(
                                        inventoryStore: store
                                    )
                                    
                                } label: {
                                    
                                    Image(systemName: "cart.fill")
                                        .font(.title2)
                                        .foregroundColor(.green)
                                }
                                
                                // 📜 ИСТОРИЯ
                                
                                NavigationLink {
                                    
                                    OrdersHistoryView(
                                        inventoryStore: store
                                    )
                                    
                                } label: {
                                    
                                    Image(systemName: "clock.arrow.circlepath")
                                        .font(.title2)
                                        .foregroundColor(.yellow)
                                }
                                
                                // 🍳 МЕНЮ
                                
                                Button {
                                    showMenu = true
                                } label: {
                                    
                                    Image(systemName: "menucard.fill")
                                        .font(.title2)
                                        .foregroundColor(.orange)
                                }
                                
                                // 📅 ГРАФИК
                                
                                Button {
                                    showSchedule = true
                                } label: {
                                    
                                    Image(systemName: "calendar")
                                        .font(.title2)
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(.top, 8)
                            
                            // НАЗВАНИЕ
                            
                            glassField(
                                "Название",
                                text: $name
                            )
                            .focused($focusedField, equals: .name)
                            
                            // ГРАММЫ
                            
                            glassField(
                                "Граммы",
                                text: $qty
                            )
                            .keyboardType(.decimalPad)
                            .focused($focusedField, equals: .qty)
                            
                            // ЦЕНА
                            
                            if type == .stock {
                                
                                glassField(
                                    "Цена за кг",
                                    text: $price
                                )
                                .keyboardType(.decimalPad)
                                .focused($focusedField, equals: .price)
                            }
                            
                            // PICKER
                            
                            Picker("", selection: $type) {
                                
                                ForEach(AddTarget.allCases, id: \.self) { item in
                                    
                                    Text(item.rawValue)
                                }
                            }
                            .pickerStyle(.segmented)
                            .tint(.orange)
                            
                            // ДОБАВИТЬ
                            
                            Button {
                                add()
                            } label: {
                                
                                Text("Добавить")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        LinearGradient(
                                            colors: [.orange, .red],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 16)
                                    )
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial.opacity(0.85))
                        .clipShape(
                            RoundedRectangle(cornerRadius: 20)
                        )
                        .padding(.horizontal)
                        .padding(.top, 60)
                        
                        // 🔍 ПОИСК
                        
                        TextField("Поиск...", text: $searchText)
                            .padding(12)
                            .background(
                                Color.white.opacity(0.08)
                            )
                            .clipShape(
                                RoundedRectangle(cornerRadius: 14)
                            )
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .padding(.top, 12)
                        
                        // 📦 СПИСОК
                        
                        VStack(spacing: 12) {
                            
                            switch type {
                                
                            case .stock:
                                
                                ForEach($store.products) { $product in
                                    
                                    ProductRow(product: $product)
                                }
                                
                            case .semi:

                                SemiLibraryView(store: store)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 14)
                        .padding(.bottom, 40)
                    }
                }
                .scrollDismissesKeyboard(.immediately)
            }
            .preferredColorScheme(.dark)
            .ignoresSafeArea(.keyboard)
            .onTapGesture {
                
                hideKeyboard()
                focusedField = nil
            }
        }
        
        // 🍳 МЕНЮ БЛЮД
        
        .sheet(isPresented: $showMenu) {
            
            DishMenuView(store: store)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        
        // 📅 ГРАФИК
        
        .sheet(isPresented: $showSchedule) {
            
            WorkScheduleView()
        }
    }
    
    // MARK: - ADD
    
    func add() {
        
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        guard let q = Double(
            qty.replacingOccurrences(of: ",", with: ".")
        ) else {
            return
        }
        
        switch type {
            
        case .stock:
            
            let pr = Double(
                price.replacingOccurrences(of: ",", with: ".")
            )
            
            let product = Product(
                name: name,
                quantityInGrams: q,
                pricePerKg: pr
            )
            
            store.products.append(product)
            
        case .semi:
            
            let semi = SemiFinishedProduct(
                name: name,
                outputQuantityInGrams: q,
                ingredients: [],
                instruction: ""
            )
            
            store.semiProducts.append(semi)
        }
        
        store.save()
        
        name = ""
        qty = ""
        price = ""
        
        focusedField = nil
        
        hideKeyboard()
    }
    
    // MARK: - FILTER
    
    var filteredSemiProducts: [SemiFinishedProduct] {
        
        searchText.isEmpty
        ? store.semiProducts
        : store.semiProducts.filter {
            $0.name.lowercased().contains(
                searchText.lowercased()
            )
        }
    }
    
    // MARK: - UI
    
    func glassField(
        _ placeholder: String,
        text: Binding<String>
    ) -> some View {
        
        TextField(placeholder, text: text)
            .padding(12)
            .background(
                Color.white.opacity(0.08)
            )
            .clipShape(
                RoundedRectangle(cornerRadius: 14)
            )
            .foregroundColor(.white)
    }
}
