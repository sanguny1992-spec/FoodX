import Foundation
import FirebaseFirestore

final class SemiShareService {
    
    private let db = Firestore.firestore()
    
    func uploadSemiProducts(
        semiProducts: [SemiFinishedProduct],
        restaurantId: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        
        let data: [[String: Any]] = semiProducts.map { semi in
            
            [
                "id": semi.id.uuidString,
                
                "name": semi.name,
                
                "grams": semi.outputQuantityInGrams,
                
                "instruction": semi.instruction,
                
                "ingredients": semi.ingredients.map {
                    
                    [
                        "name": $0.name,
                        "grams": $0.grams
                    ]
                }
            ]
        }
        
        db.collection("semi")
            .document("main")
            .setData([
                
                "createdAt": Timestamp(),
                
                "restaurantId": restaurantId,
                
                "semiProducts": data
                
            ]) { error in
                
                if let error {
                    
                    completion(.failure(error))
                    return
                }
                
                completion(
                    .success(
                        "https://foodxnew.web.app"
                    )
                )
            }
    }
}
