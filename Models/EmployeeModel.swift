import Foundation
import FirebaseFirestore

struct EmployeeModel: Identifiable, Codable {
    
    @DocumentID var id: String?
    
    var name: String
    var email: String
    
    var role: String
    var status: String
    
    var createdAt: Date = Date()
}
