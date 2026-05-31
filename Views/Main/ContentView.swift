import SwiftUI
import FirebaseFirestore

struct ContentView: View {
    
    @EnvironmentObject var auth: AuthManager
    
    @StateObject var store = InventoryStore()
    
    @State private var showMenu = false
    @State private var showSchedule = false
    
    @State private var searchText = ""
    
    @State private var name = ""
    @State private var qty = ""
    @State private var price = ""
    
    @State private var type: AddTarget = .stock
    
    @State private var showSyncAlert = false
    @State private var syncMessage = ""
    
    @FocusState private var focusedField: Field?
    
    enum Field {
        case name, qty, price
    }
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                Image("FoodX")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                Color.black.opacity(0.55)
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    
                    VStack(spacing: 18) {
                        
                        VStack(spacing: 14) {
                            
                            HStack {
                                
                                HStack(spacing: 6) {
                                    
                                    Image(systemName: "sparkles")
                                        .font(.caption2)
                                        .foregroundColor(.white.opacity(0.35))
                                    
                                    Text("By Vakulenko")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.35))
                                        .italic()
                                }
                                
                                Spacer()
                                
                                // ПОСТАВЩИКИ
                                
                                NavigationLink {
                                    
                                    SuppliersView()
                                    
                                } label: {
                                    
                                    Image(systemName: "truck.box.fill")
                                        .font(.title2)
                                        .foregroundColor(.cyan)
                                }
                                
                                // ЗАКАЗЫ
                                
                                NavigationLink {
                                    
                                    CreateOrderView(
                                        inventoryStore: store
                                    )
                                    
                                } label: {
                                    
                                    Image(systemName: "cart.fill")
                                        .font(.title2)
                                        .foregroundColor(.green)
                                }
                                
                                // ИСТОРИЯ
                                
                                NavigationLink {
                                    
                                    OrdersHistoryView(
                                        inventoryStore: store
                                    )
                                    
                                } label: {
                                    
                                    Image(systemName: "clock.arrow.circlepath")
                                        .font(.title2)
                                        .foregroundColor(.yellow)
                                }
                                
                                // МЕНЮ
                                
                                Button {
                                    
                                    showMenu = true
                                    
                                } label: {
                                    
                                    Image(systemName: "menucard.fill")
                                        .font(.title2)
                                        .foregroundColor(.orange)
                                }
                                
                                // ГРАФИК
                                
                                Button {
                                    
                                    showSchedule = true
                                    
                                } label: {
                                    
                                    Image(systemName: "calendar")
                                        .font(.title2)
                                        .foregroundColor(.blue)
                                }
                                
                                // ЧАТ
                                
                                NavigationLink {

                                    ChatView(
                                        restaurantId: "6A0C27E2-2B87-4EB3-9576-6AC17129727D"
                                    )
                                    .environmentObject(store)

                                } label: {

                                    Image(systemName: "message.fill")
                                        .font(.title2)
                                        .foregroundColor(.green)
                                }
                                
                                // WEB SYNC
                                
                                Button {
                                    
                                    syncWeb()
                                    
                                } label: {
                                    
                                    Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.purple)
                                }
                            }
                            
                            glassField(
                                "Название",
                                text: $name
                            )
                            .focused($focusedField, equals: .name)
                            
                            glassField(
                                "Граммы",
                                text: $qty
                            )
                            .keyboardType(.decimalPad)
                            .focused($focusedField, equals: .qty)
                            
                            if type == .stock {
                                
                                glassField(
                                    "Цена за кг",
                                    text: $price
                                )
                                .keyboardType(.decimalPad)
                                .focused($focusedField, equals: .price)
                            }
                            
                            Picker("", selection: $type) {
                                
                                ForEach(AddTarget.allCases, id: \.self) { item in
                                    
                                    Text(item.rawValue)
                                }
                            }
                            .pickerStyle(.segmented)
                            .tint(.orange)
                            
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
                                        RoundedRectangle(cornerRadius: 18)
                                    )
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial.opacity(0.9))
                        .clipShape(
                            RoundedRectangle(cornerRadius: 24)
                        )
                        .padding(.horizontal)
                        .padding(.top, 90)
                        
                        DashboardView(
                            showMenu: $showMenu,
                            showSchedule: $showSchedule,
                            store: store
                        )
                        .padding(.horizontal)
                        .padding(.bottom, 40)
                    }
                }
                .scrollDismissesKeyboard(.immediately)
            }
            .preferredColorScheme(.dark)
            .ignoresSafeArea(.keyboard)
            
            .onTapGesture {
                
                
                focusedField = nil
            }
            
            .toolbar {
                
                ToolbarItemGroup(placement: .topBarLeading) {
                    
                    Button {
                        
                        auth.signOut()
                        
                    } label: {
                        
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(.red)
                    }
                    
                    NavigationLink {
                        
                        EmployeesView(
                            restaurantId: "6A0C27E2-2B87-4EB3-9576-6AC17129727D"
                        )
                        
                    } label: {
                        
                        Image(systemName: "person.3.fill")
                            .foregroundColor(.purple)
                    }
                }
            }
            
            .sheet(isPresented: $showMenu) {
                
                DishMenuView(store: store)
                    .presentationDetents([.large])
            }
            
            .sheet(isPresented: $showSchedule) {
                
                WorkScheduleView()
            }
            
            .alert(
                "FoodX WEB",
                isPresented: $showSyncAlert
            ) {
                
                Button("OK") { }
                
            } message: {
                
                Text(syncMessage)
            }
        }
    }
    
    func syncWeb() {
        
        FirebaseSyncService.shared.uploadMenu(
            dishes: store.dishes
        )
        
        FirebaseSyncService.shared.uploadSemiProducts(
            store.semiProducts
        )
        
        syncMessage = "WEB версия обновлена 🚀"
        showSyncAlert = true
    }
    
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
    
    var filteredSemiProducts: [SemiFinishedProduct] {
        
        searchText.isEmpty
        ? store.semiProducts
        : store.semiProducts.filter {
            $0.name.lowercased().contains(
                searchText.lowercased()
            )
        }
    }
    
    func glassField(
        _ placeholder: String,
        text: Binding<String>
    ) -> some View {
        
        TextField(placeholder, text: text)
            .padding(14)
            .background(
                Color.white.opacity(0.08)
            )
            .clipShape(
                RoundedRectangle(cornerRadius: 16)
            )
            .foregroundColor(.white)
    }
}
