import Foundation

struct ChatWriteOffItem: Identifiable {

    let id = UUID()

    var productName: String

    var grams: Double

    var selected: Bool = true
}
