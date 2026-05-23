import Foundation
import FirebaseFirestore

struct Employee: Identifiable, Codable {
    
    var id: UUID
    
    var name: String
    
    var email: String
    
    var password: String
    
    var restaurantId: String
    
    var role: String
    
    var createdAt: Date = Date()
}
