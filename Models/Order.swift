import Foundation

struct OrderItem: Identifiable, Codable, Hashable {
    
    let id: UUID
    
    var productName: String
    
    var supplier: String
    
    var quantity: String
    
    init(
        id: UUID = UUID(),
        productName: String,
        supplier: String,
        quantity: String
    ) {
        
        self.id = id
        self.productName = productName
        self.supplier = supplier
        self.quantity = quantity
    }
}

struct Order: Identifiable, Codable, Hashable {
    
    let id: UUID
    
    var supplier: String
    
    var date: Date
    
    var items: [OrderItem]
    
    init(
        id: UUID = UUID(),
        supplier: String,
        date: Date = Date(),
        items: [OrderItem]
    ) {
        
        self.id = id
        self.supplier = supplier
        self.date = date
        self.items = items
    }
}
