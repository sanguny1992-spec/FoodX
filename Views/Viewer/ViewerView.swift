import SwiftUI
import FirebaseFirestore

struct ViewerView: View {

    let inventoryID: String

    @State private var products: [[String: Any]] = []
    @State private var semiProducts: [[String: Any]] = []

    @State private var selectedTab: Tab = .stock
    @State private var isLoading = true

    enum Tab {
        case stock, semi, schedule
    }

    var body: some View {

        VStack(spacing: 0) {

            // 🔥 ВКЛАДКИ (всегда 3)
            HStack(spacing: 0) {

                tab("Склад", .stock)
                tab("П/Ф", .semi)
                tab("График", .schedule)
            }
            .padding()
            .background(Color.black.opacity(0.85))

            if isLoading {
                Spacer()
                ProgressView("Загрузка...")
                Spacer()
            } else {

                ScrollView {

                    VStack(spacing: 14) {

                        // 📦 СКЛАД
                        if selectedTab == .stock {

                            ForEach(products.indices, id: \.self) { i in
                                let item = products[i]

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item["name"] as? String ?? "Без названия")
                                        .font(.headline)
                                        .foregroundColor(.white)

                                    Text("Граммы: \(item["quantityInGrams"] as? Double ?? 0)")
                                        .foregroundColor(.gray)

                                    if let price = item["pricePerKg"] as? Double {
                                        Text("Цена: \(price)")
                                            .foregroundColor(.orange)
                                    }
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white.opacity(0.08))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }

                        // 🥣 ПОЛУФАБРИКАТЫ
                        
                        
                        
                        if selectedTab == .semi {

                            ForEach(semiProducts.indices, id: \.self) { i in
                                let item = semiProducts[i]

                                VStack(alignment: .leading, spacing: 6) {

                                    Text(item["name"] as? String ?? "Без названия")
                                        .font(.headline)
                                        .foregroundColor(.white)

                                    Text("Выход: \(item["outputQuantityInGrams"] as? Double ?? 0) г")
                                        .foregroundColor(.gray)

                                    if let instruction = item["instruction"] as? String,
                                       !instruction.isEmpty {
                                        Text(instruction)
                                            .foregroundColor(.white.opacity(0.8))
                                            .font(.caption)
                                    }
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white.opacity(0.08))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }

                        // 📅 ГРАФИК (пока заглушка)
                        if selectedTab == .schedule {

                            Text("График смен будет добавлен позже")
                                .foregroundColor(.gray)
                                .padding()
                        }
                    }
                    .padding()
                }
            }
        }
        .background(Color.black.ignoresSafeArea())
        .onAppear {
            loadData()
        }
    }

    // MARK: - TAB
    func tab(_ title: String, _ tab: Tab) -> some View {
        Button {
            selectedTab = tab
        } label: {
            Text(title)
                .frame(maxWidth: .infinity)
                .padding(10)
                .background(selectedTab == tab ? Color.orange : Color.clear)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }

    // MARK: - LOAD FIRESTORE (исправлено под твой формат)
    func loadData() {

        let db = Firestore.firestore()

        db.collection("inventories").document(inventoryID).getDocument { snap, error in

            guard let data = snap?.data(), error == nil else {
                isLoading = false
                return
            }

            // 📦 PRODUCTS
            if let arr = data["products"] as? [[String: Any]] {
                products = arr
            }

            // 🥣 SEMI PRODUCTS
            if let arr = data["semiProducts"] as? [[String: Any]] {
                semiProducts = arr
            }

            isLoading = false
        }
    }
}
