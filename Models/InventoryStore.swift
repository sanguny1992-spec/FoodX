import Foundation
import SwiftUI
import Combine

final class InventoryStore: ObservableObject {

    // MARK: DATA

    @Published var products: [Product] = []

    @Published var semiProducts: [SemiFinishedProduct] = []

    @Published var dishes: [Dish] = []

    @Published var orders: [Order] = []

    @Published var writeOffs: [WriteOffRecord] = []

    // MARK: KEYS

    private let productsKey = "products_key"

    private let semiKey = "semi_products_key"

    private let dishesKey = "dishes_key"

    private let ordersKey = "orders_key"

    private let writeOffsKey = "writeoffs_key"

    // MARK: INIT

    init() {
        load()
    }

    // MARK: SAVE

    func save() {

        if let encoded = try? JSONEncoder().encode(products) {

            UserDefaults.standard.set(
                encoded,
                forKey: productsKey
            )
        }

        if let encoded = try? JSONEncoder().encode(semiProducts) {

            UserDefaults.standard.set(
                encoded,
                forKey: semiKey
            )
        }

        if let encoded = try? JSONEncoder().encode(dishes) {

            UserDefaults.standard.set(
                encoded,
                forKey: dishesKey
            )
        }

        if let encoded = try? JSONEncoder().encode(orders) {

            UserDefaults.standard.set(
                encoded,
                forKey: ordersKey
            )
        }

        if let encoded = try? JSONEncoder().encode(writeOffs) {

            UserDefaults.standard.set(
                encoded,
                forKey: writeOffsKey
            )
        }
    }

    // MARK: LOAD

    func load() {

        if let data = UserDefaults.standard.data(
            forKey: productsKey
        ),
        let decoded = try? JSONDecoder().decode(
            [Product].self,
            from: data
        ) {

            products = decoded
        }

        if let data = UserDefaults.standard.data(
            forKey: semiKey
        ),
        let decoded = try? JSONDecoder().decode(
            [SemiFinishedProduct].self,
            from: data
        ) {

            semiProducts = decoded
        }

        if let data = UserDefaults.standard.data(
            forKey: dishesKey
        ),
        let decoded = try? JSONDecoder().decode(
            [Dish].self,
            from: data
        ) {

            dishes = decoded
        }

        if let data = UserDefaults.standard.data(
            forKey: ordersKey
        ),
        let decoded = try? JSONDecoder().decode(
            [Order].self,
            from: data
        ) {

            orders = decoded
        }

        if let data = UserDefaults.standard.data(
            forKey: writeOffsKey
        ),
        let decoded = try? JSONDecoder().decode(
            [WriteOffRecord].self,
            from: data
        ) {

            writeOffs = decoded
        }
    }
}
