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
                                // PDF BUTTON

                                Button {
                                    
                                    exportPDF(order: order)
                                    
                                } label: {
                                    
                                    HStack {
                                        
                                        Image(systemName: "doc.richtext")
                                        
                                        Text("PDF")
                                            .fontWeight(.bold)
                                    }
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(Color.orange)
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 14)
                                    )
                                }
                                .padding(.top, 6)
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
    // MARK: - PDF

    func exportPDF(order: Order) {
        
        guard let url =
                TTKPDFExporter.exportOrder(order: order)
        else {
            return
        }
        
        let vc = UIActivityViewController(
            activityItems: [url],
            applicationActivities: nil
        )
        
        UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?
            .windows
            .first?
            .rootViewController?
            .present(vc, animated: true)
    }
}
