import SwiftUI

struct CreateSemiView: View {

    @Environment(\.dismiss) private var dismiss

    @ObservedObject var store: InventoryStore

    @State private var name = ""
    @State private var grams = ""
    @State private var instruction = ""
    

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(spacing: 24) {

                    VStack(alignment: .leading, spacing: 8) {

                        Text("Название")
                            .foregroundColor(.gray)

                        TextField(
                            "Например: Соус Бургер",
                            text: $name
                        )
                        .textFieldStyle(.roundedBorder)
                    }

                    VStack(alignment: .leading, spacing: 8) {

                        Text("Выход (г)")
                            .foregroundColor(.gray)

                        TextField(
                            "1000",
                            text: $grams
                        )
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                    }

                    VStack(alignment: .leading, spacing: 8) {

                        Text("Технология приготовления")
                            .foregroundColor(.gray)

                        TextEditor(text: $instruction)
                            .frame(height: 220)
                            .padding(8)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(
                                RoundedRectangle(cornerRadius: 14)
                            )
                    }

                    Button {

                        createSemi()

                    } label: {

                        Text("Создать полуфабрикат")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 16)
                            )
                    }
                    .disabled(name.isEmpty)

                }
                .padding()
            }
            .navigationTitle("Новый полуфабрикат")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    func createSemi() {

        let value = Double(
            grams.replacingOccurrences(of: ",", with: ".")
        ) ?? 0

        let semi = SemiFinishedProduct(

            name: name,

            outputQuantityInGrams: value, ingredients: [],

            instruction: instruction
        )

        store.semiProducts.append(semi)

        store.save()

        FirebaseSyncService.shared.syncAll(
            dishes: store.dishes,
            semiProducts: store.semiProducts
        )

        dismiss()
    }
}
