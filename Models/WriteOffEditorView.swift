import SwiftUI

struct WriteOffEditorView: View {

    @EnvironmentObject var store: InventoryStore
    @Environment(\.dismiss) private var dismiss

    @State var items: [WriteOffDraftItem]

    var body: some View {

        NavigationView {

            List {

                ForEach($items, id: \.id) { $item in

                    VStack(alignment: .leading, spacing: 10) {

                        Toggle(
                            item.productName,
                            isOn: $item.isSelected
                        )

                        HStack {

                            Text("Граммы")

                            Spacer()

                            TextField(
                                "0",
                                value: $item.grams,
                                format: .number
                            )
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }

            .navigationTitle("Списание")

            .toolbar {

                ToolbarItem(placement: .cancellationAction) {

                    Button("Отмена") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {

                    Button("Списать") {

                        performWriteOff()

                        dismiss()
                    }
                }
            }
        }
    }

    private func performWriteOff() {

        for item in items where item.isSelected {

            if let index = store.products.firstIndex(where: {
                $0.name.lowercased() ==
                item.productName.lowercased()
            }) {

                store.products[index].quantityInGrams -= item.grams

                if store.products[index].quantityInGrams < 0 {
                    store.products[index].quantityInGrams = 0
                }
            }
        }

        store.save()
    }
}
