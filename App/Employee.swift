import Foundation
import FirebaseFirestore

struct Employee: Identifiable, Codable {
    
    var id: String
    
    var name: String
    
    var email: String
    
    var restaurantId: String
    
    var role: String
    
    var status: String
    
    var createdAt: Date = Date()
}
