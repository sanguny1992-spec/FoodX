import Foundation

struct Restaurant: Identifiable, Codable {
    
    var id: String
    var name: String
    var code: String
    var ownerId: String
    
    var createdAt: Date = Date()
}
