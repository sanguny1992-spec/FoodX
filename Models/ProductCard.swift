import SwiftUI

struct ProductCard: View {

    var product: Product

    var onDelete: () -> Void
    var onSave: () -> Void

    var body: some View {

        VStack(alignment: .leading, spacing: 10) {

            Text(product.name)
                .font(.headline)
                .foregroundColor(.white)

            Text("Кол-во: \(Int(product.quantityInGrams)) г")
                .foregroundColor(.gray)

            HStack {

                Button("Сохранить") {
                    onSave()
                }
                .foregroundColor(.green)

                Spacer()

                Button("Удалить") {
                    onDelete()
                }
                .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
