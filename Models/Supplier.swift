import Foundation

struct Supplier: Identifiable, Codable, Hashable {
    
    let id: UUID
    
    var name: String
    
    var category: String
    
    var managerName: String
    
    var phone: String
    
    var comment: String
    
    init(
        id: UUID = UUID(),
        name: String,
        category: String = "",
        managerName: String = "",
        phone: String = "",
        comment: String = ""
    ) {
        
        self.id = id
        self.name = name
        self.category = category
        self.managerName = managerName
        self.phone = phone
        self.comment = comment
    }
}
