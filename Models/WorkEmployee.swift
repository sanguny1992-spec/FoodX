import Foundation

struct WorkEmployee: Identifiable, Codable {

    let id: UUID

    var name: String

    var monthDays: [String: [Int]]

    init(
        id: UUID = UUID(),
        name: String,
        monthDays: [String: [Int]] = [:]
    ) {

        self.id = id
        self.name = name
        self.monthDays = monthDays
    }
}
