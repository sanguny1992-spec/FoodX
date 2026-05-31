import Foundation

struct WriteOffRecord: Identifiable, Codable {

    let id: UUID

    var productName: String

    var grams: Double

    var reason: String

    var employee: String

    var date: Date

    init(
        id: UUID = UUID(),
        productName: String,
        grams: Double,
        reason: String,
        employee: String,
        date: Date = Date()
    ) {
        self.id = id
        self.productName = productName
        self.grams = grams
        self.reason = reason
        self.employee = employee
        self.date = date
    }
}
