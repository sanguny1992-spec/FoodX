import SwiftUI

struct WriteOffsView: View {

    @ObservedObject var store: InventoryStore

    var body: some View {

        NavigationStack {

            List {

                if store.writeOffs.isEmpty {

                    Text("Списаний пока нет")
                        .foregroundColor(.gray)

                } else {

                    ForEach(store.writeOffs) { record in

                        VStack(alignment: .leading, spacing: 6) {

                            Text(record.productName)
                                .font(.headline)

                            Text("Количество: \(Int(record.grams)) г")

                            Text("Причина: \(record.reason)")

                            Text("Сотрудник: \(record.employee)")

                            Text(
                                record.date.formatted(
                                    date: .numeric,
                                    time: .shortened
                                )
                            )
                            .font(.caption)
                            .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Списания")
        }
    }
}
