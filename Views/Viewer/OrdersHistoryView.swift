import SwiftUI

struct OrdersHistoryView: View {
    
    @ObservedObject var inventoryStore: InventoryStore
    
    var reversedOrders: [Order] {
        inventoryStore.orders.reversed()
    }
    
    var body: some View {
        
        ZStack {
            
            Image("FoodX")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            Color.black.opacity(0.85)
                .ignoresSafeArea()
            
            if reversedOrders.isEmpty {
                
                VStack(spacing: 14) {
                    
                    Image(systemName: "doc.text")
                        .font(.system(size: 50))
                        .foregroundColor(.orange)
                    
                    Text("История заказов пуста")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                    
                    Text("Созданные заказы будут отображаться здесь")
                        .foregroundColor(.gray)
                }
                
            } else {
                
                ScrollView(showsIndicators: false) {
                    
                    VStack(spacing: 14) {
                        
                        ForEach(reversedOrders) { order in
                            
                            VStack(
                                alignment: .leading,
                                spacing: 10
                            ) {
                                
                                HStack {
                                    
                                    Text(order.supplier)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Text(
                                        order.date.formatted(
                                            date: .abbreviated,
                                            time: .shortened
                                        )
                                    )
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                }
                                
                                Divider()
                                    .background(
                                        Color.gray.opacity(0.4)
                                    )
                                
                                ForEach(order.items) { item in
                                    
                                    HStack {
                                        
                                        Text(item.productName)
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                        
                                        Text(item.quantity)
                                            .foregroundColor(.orange)
                                    }
                                }
                            }
                            .padding()
                            .background(
                                Color.white.opacity(0.06)
                            )
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: 24
                                )
                            )
                        }
                    }
                    .padding()
                    .padding(.top, 20)
                }
            }
        }
        .navigationTitle("История заказов")
        .navigationBarTitleDisplayMode(.inline)
    }
}
