import SwiftUI

struct StockView: View {

    @ObservedObject var store: InventoryStore

    @State private var searchText = ""

    var filteredProducts: [Product] {

        searchText.isEmpty
        ? store.products
        : store.products.filter {

            $0.name.lowercased().contains(
                searchText.lowercased()
            )
        }
    }

    var body: some View {

        ScrollView {

            VStack(spacing: 14) {

                TextField(
                    "Поиск...",
                    text: $searchText
                )
                .padding(14)
                .background(
                    Color.white.opacity(0.08)
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 16
                    )
                )

                ForEach(filteredProducts) { product in

                    ProductCard(
                        product: product
                    )
                }
            }
            .padding()
        }
        .navigationTitle("Склад")
        .background(
            Color.black.ignoresSafeArea()
        )
    }
}
