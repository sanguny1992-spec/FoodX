import Foundation

struct Ingredient: Identifiable, Codable, Hashable {

    let id: UUID

    var name: String

    var grams: Double

    init(
        id: UUID = UUID(),
        name: String,
        grams: Double
    ) {

        self.id = id
        self.name = name
        self.grams = grams
    }
}
