import Foundation
import FirebaseFirestore

final class MenuShareService {
    
    private let db = Firestore.firestore()
    
    func uploadMenu(
        dishes: [Dish],
        restaurantId: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        
        let sharedDishes = dishes.map {
            
            ShareDish(
                
                id: $0.id.uuidString,
                
                name: $0.name,
                
                category: $0.category,
                
                grams: $0.outputQuantityInGrams,
                
                instruction: $0.instruction,
                
                ingredients: $0.ingredients.map {

                    ShareIngredient(
                        name: $0.name,
                        grams: $0.grams
                    )
                }
            )
        }
        
        do {
            
            let data = try sharedDishes.map {
                try Firestore.Encoder().encode($0)
            }
            
            let doc = db
                .collection("restaurants")
                .document(restaurantId)
                .collection("menus")
                .document("main")
            
            doc.setData([
                
                "createdAt": Timestamp(),
                "restaurantId": restaurantId,
                "dishes": data
                
            ]) { error in
                
                if let error {
                    
                    completion(.failure(error))
                    return
                }
                
                completion(
                    .success(
                        "https://foodxnew.web.app/menu/\(restaurantId)"
                    )
                )
            }
            
        } catch {
            
            completion(.failure(error))
        }
    }
}
