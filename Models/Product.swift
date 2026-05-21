import Foundation

struct Product: Identifiable, Codable, Hashable {

    let id: UUID

    var name: String

    var quantityInGrams: Double

    var pricePerKg: Double?

    init(
        id: UUID = UUID(),
        name: String,
        quantityInGrams: Double,
        pricePerKg: Double? = nil
    ) {

        self.id = id
        self.name = name
        self.quantityInGrams = quantityInGrams
        self.pricePerKg = pricePerKg
    }

    // 💰 ОБЩАЯ СТОИМОСТЬ
    var totalPrice: Double {

        guard let pricePerKg else {
            return 0
        }

        return (quantityInGrams / 1000) * pricePerKg
    }
}
