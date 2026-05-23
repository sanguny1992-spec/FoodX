import SwiftUI
import FirebaseFirestore

struct ContentView: View {
    
    @EnvironmentObject var auth: AuthManager
    
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
    
    @State private var showInviteAlert = false
    @State private var inviteCode = ""
    
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
                
                // MAIN SCROLL
                
                ScrollView(showsIndicators: false) {
                    
                    VStack(spacing: 0) {
                        
                        // TOP PANEL
                        
                        VStack(spacing: 10) {
                            
                            HStack {
                                
                                HStack(spacing: 6) {
                                    
                                    Image(systemName: "sparkles")
                                        .font(.caption2)
                                        .foregroundColor(.white.opacity(0.35))
                                    
                                    Text("By Zabredun")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.35))
                                        .italic()
                                }
                                
                                Spacer()
                                
                                // 🚚 ПОСТАВЩИКИ
                                
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
                        .padding(.top, 90)
                        
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
                                
                                ForEach(filteredSemiProducts) { semi in
                                    
                                    SemiRow(
                                        store: store,
                                        semi: semi
                                    )
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 14)
                        
                        // 👥 СОТРУДНИКИ
                        
                        NavigationLink {
                            
                            EmployeesView(
                                restaurantId: "demo_restaurant"
                            )
                            
                        } label: {
                            
                            VStack(spacing: 8) {
                                
                                Image(systemName: "person.3.fill")
                                    .font(.system(size: 28))
                                
                                Text("Сотрудники")
                                    .font(.headline)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                Color.white.opacity(0.06)
                            )
                            .clipShape(
                                RoundedRectangle(cornerRadius: 24)
                            )
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
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
            .toolbar {
                
                ToolbarItem(placement: .topBarLeading) {
                    
                    HStack(spacing: 10) {
                        
                        Button {
                            
                            auth.signOut()
                            
                        } label: {
                            
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .foregroundColor(.red)
                        }
                        
                        Text("By Zabredun")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.35))
                            .italic()
                            .blur(radius: 0.3)
                    }
                }
            }
            .sheet(isPresented: $showMenu) {
                
                DishMenuView(store: store)
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showSchedule) {
                
                WorkScheduleView()
            }
            .alert(
                "Код приглашения",
                isPresented: $showInviteAlert
            ) {
                
                Button("OK") { }
                
            } message: {
                
                Text(inviteCode)
            }
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
