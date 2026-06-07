import SwiftUI

struct AddProductView: View {

    @ObservedObject var store: InventoryStore
    @Environment(\.dismiss) var dismiss

    @State private var name = ""
    @State private var quantity = ""
    @State private var price = ""

    var body: some View {

        VStack(spacing: 16) {

            TextField("Название", text: $name)
                .textFieldStyle(.roundedBorder)

            TextField("Вес (г)", text: $quantity)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)

            TextField("Цена за кг", text: $price)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)

            Button("Сохранить") {

                guard let qty = Double(quantity) else { return }
                let pr = Double(price) ?? 0

                let newProduct = Product(
                    name: name,
                    quantityInGrams: qty,
                    pricePerKg: pr
                )

                store.products.append(newProduct)
                store.save()

                dismiss()
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.orange)
            .cornerRadius(12)

            Spacer()
        }
        .padding()
        .navigationTitle("Новый продукт")
    }
}
