import Foundation
import FirebaseFirestore

struct ChatMessage: Identifiable, Codable {
    
    @DocumentID
    var id: String?
    
    var sender: String
    
    var text: String
    
    var createdAt: Timestamp?
}
