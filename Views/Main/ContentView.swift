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
                        
                        VStack(spacing: 18) {
                            
                            Text(auth.restaurantName)
                                .font(.title.bold())
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                            
                            Text(auth.restaurantName)
                                .font(.title.bold())
                                .foregroundColor(.white)

                            DashboardView(
                                showMenu: $showMenu,
                                showSchedule: $showSchedule,
                                store: store
                            )
                            .environmentObject(auth)
                            .padding(.horizontal)
                            .padding(.top, 90)
                            .padding(.bottom, 40)
                        }
                        
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
                            restaurantId: auth.restaurantId
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
