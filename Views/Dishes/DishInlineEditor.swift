
import SwiftUI

struct DishInlineEditor: View {
    
    @Binding var dish: SemiFinishedProduct
    
    var onDone: () -> Void
    
    var body: some View {
        
        VStack(spacing: 10) {
            
            TextField("Название блюда", text: $dish.name)
                .padding(10)
                .background(Color.white.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .foregroundColor(.white)
            
            TextField(
                "Граммы",
                value: $dish.outputQuantityInGrams,
                format: .number
            )
            .padding(10)
            .background(Color.white.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .foregroundColor(.white)
            .keyboardType(.decimalPad)
            
            TextField(
                "Описание приготовления",
                text: $dish.instruction,
                axis: .vertical
            )
            .padding(10)
            .background(Color.white.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .foregroundColor(.white)
            .lineLimit(4...8)
            
            Button {
                onDone()
            } label: {
                Text("Готово")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding()
        .background(.ultraThinMaterial.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}
