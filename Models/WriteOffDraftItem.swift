import Foundation

struct WriteOffDraftItem: Identifiable {

    let id = UUID()

    var productName: String

    var grams: Double

    var selected: Bool = true
}
