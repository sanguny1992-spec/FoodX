import Foundation

struct Dish: Identifiable, Codable {
    
    let id: UUID
    
    var name: String
    
    // ✅ КАТЕГОРИЯ
    
    var category: String
    
    // ✅ ФОТО
    
    var imageData: Data?
    
    var outputQuantityInGrams: Double
    
    var ingredients: [Ingredient]
    
    var instruction: String
    
    init(
        id: UUID = UUID(),
        name: String,
        category: String = "Без категории",
        imageData: Data? = nil,
        outputQuantityInGrams: Double,
        ingredients: [Ingredient],
        instruction: String
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.imageData = imageData
        self.outputQuantityInGrams = outputQuantityInGrams
        self.ingredients = ingredients
        self.instruction = instruction
    }
}
