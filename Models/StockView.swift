import SwiftUI

struct StockView: View {

    @ObservedObject var store: InventoryStore

    @State private var searchText = ""
    @State private var selectedProduct: Product?
    @State private var showAddProduct = false

    var filteredProducts: [Product] {
        searchText.isEmpty
        ? store.products
        : store.products.filter {
            $0.name.lowercased()
                .contains(searchText.lowercased())
        }
    }

    var body: some View {

        ScrollView {

            VStack(spacing: 14) {

                // MARK: - SEARCH
                TextField("Поиск...", text: $searchText)
                    .padding(14)
                    .background(Color.white.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .foregroundColor(.white)

                // MARK: - ADD BUTTON
                Button {
                    showAddProduct = true
                } label: {
                    Text("➕ Добавить продукт")
                        .foregroundColor(.orange)
                        .padding(.vertical, 8)
                }

                // MARK: - LIST
                if filteredProducts.isEmpty {

                    Text("Склад пуст")
                        .foregroundColor(.gray)
                        .padding(.top, 40)

                } else {

                    VStack(spacing: 12) {

                        ForEach(filteredProducts) { product in

                            ProductCard(
                                product: product,
                                onDelete: {
                                    store.delete(product: product)
                                },
                                onSave: {
                                    store.update(product: product)
                                }
                            )
                            .onTapGesture {
                                selectedProduct = product
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Склад")
        .background(Color.black.ignoresSafeArea())

        // MARK: - EDIT PRODUCT SHEET
        .sheet(item: $selectedProduct) { product in
            EditProductView(store: store, product: product)
        }

        // MARK: - ADD PRODUCT SHEET
        .sheet(isPresented: $showAddProduct) {
            AddProductView(store: store)
        }
    }
}
