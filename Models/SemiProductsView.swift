import SwiftUI

struct SemiProductsView: View {

    @ObservedObject var store: InventoryStore

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(spacing: 12) {

                    if store.semiProducts.isEmpty {

                        Text("Полуфабрикатов пока нет")
                            .foregroundColor(.gray)
                            .padding(.top, 50)

                    } else {

                        ForEach(store.semiProducts) { semi in

                            SemiRow(
                                store: store,
                                semi: semi
                            )
                        }
                    }
                }
                .padding()
            }
            .background(Color.black)
            .navigationTitle("Полуфабрикаты")
        }
    }
}
