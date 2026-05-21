import Foundation

struct SemiFinishedProduct: Identifiable, Codable, Hashable {

    let id: UUID

    var name: String

    var outputQuantityInGrams: Double

    var ingredients: [Ingredient]

    var instruction: String

    init(
        id: UUID = UUID(),
        name: String,
        outputQuantityInGrams: Double,
        ingredients: [Ingredient],
        instruction: String
    ) {

        self.id = id
        self.name = name
        self.outputQuantityInGrams = outputQuantityInGrams
        self.ingredients = ingredients
        self.instruction = instruction
    }
}
