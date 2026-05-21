import SwiftUI

struct CreateOrderView: View {
    
    @ObservedObject var inventoryStore: InventoryStore
    
    @StateObject private var supplierStore = SupplierStore()
    
    @State private var items: [OrderItem] = []
    
    @State private var productName = ""
    @State private var supplier = ""
    @State private var quantity = ""
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                // BACKGROUND
                
                Image("FoodX")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                Color.black.opacity(0.85)
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    
                    VStack(spacing: 18) {
                        
                        // TITLE
                        
                        Text("Составить заказ")
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                            .padding(.top, 30)
                        
                        // PRODUCT
                        
                        TextField(
                            "Название продукта",
                            text: $productName
                        )
                        .padding()
                        .background(
                            Color.white.opacity(0.08)
                        )
                        .clipShape(
                            RoundedRectangle(cornerRadius: 18)
                        )
                        .foregroundColor(.white)
                        
                        // SUPPLIER PICKER
                        
                        Menu {
                            
                            ForEach(
                                supplierStore.suppliers
                            ) { item in
                                
                                Button(item.name) {
                                    supplier = item.name
                                }
                            }
                            
                        } label: {
                            
                            HStack {
                                
                                Text(
                                    supplier.isEmpty
                                    ? "Выбрать поставщика"
                                    : supplier
                                )
                                .foregroundColor(
                                    supplier.isEmpty
                                    ? .gray
                                    : .white
                                )
                                
                                Spacer()
                                
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.orange)
                            }
                            .padding()
                            .background(
                                Color.white.opacity(0.08)
                            )
                            .clipShape(
                                RoundedRectangle(cornerRadius: 18)
                            )
                        }
                        
                        // QUANTITY
                        
                        TextField(
                            "Количество",
                            text: $quantity
                        )
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(
                            Color.white.opacity(0.08)
                        )
                        .clipShape(
                            RoundedRectangle(cornerRadius: 18)
                        )
                        .foregroundColor(.white)
                        
                        // ADD ITEM
                        
                        Button {
                            addItem()
                        } label: {
                            
                            Text("Добавить в заказ")
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.orange)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 18)
                                )
                        }
                        
                        // ITEMS
                        
                        VStack(spacing: 12) {
                            
                            ForEach(items) { item in
                                
                                VStack(
                                    alignment: .leading,
                                    spacing: 8
                                ) {
                                    
                                    Text(item.productName)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    
                                    Text(
                                        "Поставщик: \(item.supplier)"
                                    )
                                    .foregroundColor(.gray)
                                    
                                    Text(
                                        "Количество: \(item.quantity)"
                                    )
                                    .foregroundColor(.orange)
                                }
                                .frame(
                                    maxWidth: .infinity,
                                    alignment: .leading
                                )
                                .padding()
                                .background(
                                    Color.white.opacity(0.05)
                                )
                                .clipShape(
                                    RoundedRectangle(
                                        cornerRadius: 20
                                    )
                                )
                            }
                        }
                        
                        // SAVE ORDER
                        
                        Button {
                            saveOrder()
                        } label: {
                            
                            Text("Сохранить заказ")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 18)
                                )
                        }
                        .padding(.top, 10)
                    }
                    .padding()
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    // MARK: ADD ITEM
    
    func addItem() {
        
        guard !productName.isEmpty else {
            return
        }
        
        let item = OrderItem(
            productName: productName,
            supplier: supplier,
            quantity: quantity
        )
        
        items.append(item)
        
        productName = ""
        quantity = ""
    }
    
    // MARK: SAVE ORDER
    
    func saveOrder() {
        
        guard !items.isEmpty else {
            return
        }
        
        let order = Order(
            supplier: supplier.isEmpty
            ? "Без поставщика"
            : supplier,
            items: items
        )
        
        inventoryStore.orders.append(order)
        
        inventoryStore.save()
        
        items.removeAll()
        
        productName = ""
        quantity = ""
    }
}
