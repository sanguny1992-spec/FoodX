import SwiftUI

struct EditProductView: View {

    @ObservedObject var store: InventoryStore
    var product: Product
    @Environment(\.dismiss) var dismiss

    @State private var name: String
    @State private var grams: String
    @State private var price: String

    init(store: InventoryStore, product: Product) {
        self.store = store
        self.product = product

        _name = State(initialValue: product.name)
        _grams = State(initialValue: String(product.quantityInGrams))
        _price = State(initialValue: String(product.pricePerKg ?? 0))
    }

    var body: some View {

        VStack(spacing: 16) {

            TextField("Название", text: $name)
                .textFieldStyle(.roundedBorder)

            TextField("Вес (г)", text: $grams)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)

            TextField("Цена за кг", text: $price)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)

            Button("Сохранить") {

                guard let index = store.products.firstIndex(where: { $0.id == product.id }) else {
                    return
                }

                store.products[index].name = name
                store.products[index].quantityInGrams = Double(grams) ?? 0
                store.products[index].pricePerKg = Double(price)

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
    }
}
