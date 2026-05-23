import Foundation
import FirebaseFirestore
import FirebaseAuth

final class RestaurantService {

    private let db = Firestore.firestore()

    func createRestaurant(
        name: String,
        completion: @escaping (String?) -> Void
    ) {

        guard let uid =
                Auth.auth().currentUser?.uid
        else {
            completion(nil)
            return
        }

        let restaurantId = UUID().uuidString

        let restaurant = Restaurant(
            id: restaurantId,
            name: name,
            ownerId: uid
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
}
