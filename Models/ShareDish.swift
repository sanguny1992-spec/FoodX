import Foundation

struct ShareDish: Codable {

    var id: String

    var name: String

    var category: String

    var grams: Double

    var instruction: String

    var ingredients: [String]
}
