import Foundation
import SwiftUI
import Combine

final class InventoryStore: ObservableObject {

    @Published var products: [Product] = []

    @Published var semiProducts: [SemiFinishedProduct] = []

    // ГОТОВЫЕ БЛЮДА
    @Published var dishes: [Dish] = []

    // ЗАКАЗЫ
    @Published var orders: [Order] = []

    private let productsKey = "products_key"

    private let semiKey = "semi_products_key"

    private let dishesKey = "dishes_key"

    private let ordersKey = "orders_key"

    init() {
        load()
    }

    // MARK: SAVE

    func save() {

        // PRODUCTS

        if let encoded = try? JSONEncoder().encode(products) {

            UserDefaults.standard.set(
                encoded,
                forKey: productsKey
            )
        }

        // SEMI

        if let encoded = try? JSONEncoder().encode(semiProducts) {

            UserDefaults.standard.set(
                encoded,
                forKey: semiKey
            )
        }

        // DISHES

        if let encoded = try? JSONEncoder().encode(dishes) {

            UserDefaults.standard.set(
                encoded,
                forKey: dishesKey
            )
        }

        // ORDERS

        if let encoded = try? JSONEncoder().encode(orders) {

            UserDefaults.standard.set(
                encoded,
                forKey: ordersKey
            )
        }
    }

    // MARK: LOAD

    func load() {

        // PRODUCTS

        if let data = UserDefaults.standard.data(
            forKey: productsKey
        ),
           let decoded = try? JSONDecoder().decode(
                [Product].self,
                from: data
           ) {

            products = decoded
        }

        // SEMI

        if let data = UserDefaults.standard.data(
            forKey: semiKey
        ),
           let decoded = try? JSONDecoder().decode(
                [SemiFinishedProduct].self,
                from: data
           ) {

            semiProducts = decoded
        }

        // DISHES

        if let data = UserDefaults.standard.data(
            forKey: dishesKey
        ),
           let decoded = try? JSONDecoder().decode(
                [Dish].self,
                from: data
           ) {

            dishes = decoded
        }

        // ORDERS

        if let data = UserDefaults.standard.data(
            forKey: ordersKey
        ),
           let decoded = try? JSONDecoder().decode(
                [Order].self,
                from: data
           ) {

            orders = decoded
        }
    }
}
