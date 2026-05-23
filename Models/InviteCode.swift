import Foundation

struct InviteCode: Codable, Identifiable {
    
    var id: String
    
    var code: String
    
    var restaurantId: String
    
    var createdAt: Date = Date()
    
    var isActive: Bool = true
}
