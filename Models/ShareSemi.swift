import Foundation

struct ShareSemi: Codable, Identifiable {
    
    var id: String
    var name: String
    var grams: Double
    var instruction: String
    var ingredients: [String]
}
