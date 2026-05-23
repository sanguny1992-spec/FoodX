import Foundation
import FirebaseFirestore

final class SemiShareService {
    
    private let db = Firestore.firestore()
    
    func uploadSemiProducts(
        semiProducts: [SemiFinishedProduct],
        restaurantId: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        
        let shared = semiProducts.map {
            
            ShareSemi(
                id: $0.id.uuidString,
                name: $0.name,
                grams: $0.outputQuantityInGrams,
                instruction: $0.instruction,
                ingredients: $0.ingredients.map {
                    "\($0.name) — \(Int($0.grams)) г"
                }
            )
        }
        
        do {
            
            let data = try shared.map {
                try Firestore.Encoder().encode($0)
            }
            
            db.collection("restaurants")
                .document(restaurantId)
                .collection("semi")
                .document("main")
                .setData([
                    "createdAt": Timestamp(),
                    "items": data
                ]) { error in
                    
                    if let error {
                        completion(.failure(error))
                        return
                    }
                    
                    completion(
                        .success(
                            "https://foodxnew.web.app/semi/\(restaurantId)"
                        )
                    )
                }
            
        } catch {
            completion(.failure(error))
        }
    }
}
