import SwiftUI

struct ProductRow: View {
    
    @Binding var product: Product
    
    var body: some View {
        
        VStack(spacing: 16) {
            
            // NAME
            TextField(
                "Название продукта",
                text: $product.name
            )
            .foregroundColor(.white)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.white.opacity(0.06))
            )
            
            HStack(spacing: 12) {
                
                // QUANTITY
                VStack(alignment: .leading, spacing: 8) {
                    
                    Text("Количество")
                        .foregroundColor(.white.opacity(0.7))
                        .font(.caption)
                    
                    TextField(
                        "0",
                        value: $product.quantityInGrams,
                        format: .number
                    )
                    .keyboardType(.decimalPad)
                    .foregroundColor(.orange)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color.white.opacity(0.06))
                    )
                }
                
                // PRICE
                VStack(alignment: .leading, spacing: 8) {
                    
                    Text("Цена за кг")
                        .foregroundColor(.white.opacity(0.7))
                        .font(.caption)
                    
                    TextField(
                        "0",
                        value: $product.pricePerKg,
                        format: .number
                    )
                    .keyboardType(.decimalPad)
                    .foregroundColor(.green)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color.white.opacity(0.06))
                    )
                }
            }
            
            // TOTAL
            HStack {
                
                Text("Стоимость:")
                    .foregroundColor(.white.opacity(0.7))
                
                Spacer()
                
                Text("\(Int(product.totalPrice)) ₽")
                    .foregroundColor(.orange)
                    .fontWeight(.bold)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white.opacity(0.05))
        )
    }
}
