import Foundation
import FirebaseFirestore
import FirebaseAuth

final class RestaurantService {

    private let db = Firestore.firestore()

    func createRestaurant(
        name: String,
        completion: @escaping (String?) -> Void
    ) {

                guard let ownerId =
                    Auth.auth().currentUser?.uid
                else {
                    
                    completion(nil)
                    return
                }

        let restaurantId = UUID().uuidString

        let restaurant = Restaurant(
            id: restaurantId,
            name: name,
            code: name
                .lowercased()
                .replacingOccurrences(of: " ", with: "-"),
            ownerId: ownerId,
            createdAt: Date()
        )

        do {

            try db
                .collection("restaurants")
                .document(restaurantId)
                .setData(from: restaurant)

            completion(restaurantId)

        } catch {

            print(error.localizedDescription)
            completion(nil)
        }
    }
    func fetchRestaurantByCode(
        code: String,
        completion: @escaping (Restaurant?) -> Void
    ) {
        
        db.collection("restaurants")
            .whereField("code", isEqualTo: code)
            .getDocuments { snapshot, error in
                
                if let error {
                    
                    print(error.localizedDescription)
                    completion(nil)
                    return
                }
                
                guard let document =
                    snapshot?.documents.first
                else {
                    
                    completion(nil)
                    return
                }
                
                do {
                    
                    let restaurant =
                        try document.data(as: Restaurant.self)
                    
                    completion(restaurant)
                    
                } catch {
                    
                    print(error.localizedDescription)
                    completion(nil)
                }
            }
    }
}
