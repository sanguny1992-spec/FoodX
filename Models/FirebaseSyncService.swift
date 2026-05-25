
import Foundation
import FirebaseFirestore

final class FirebaseSyncService {

    static let shared = FirebaseSyncService()

    private let db = Firestore.firestore()

    // MARK: - FULL WEB SYNC

    func syncAll(
        dishes: [Dish],
        semiProducts: [SemiFinishedProduct]
    ) {

        uploadMenu(dishes: dishes)
        uploadSemiProducts(semiProducts)
    }

    // MARK: - MENU

func uploadMenu(dishes: [Dish]) {

        let mapped: [[String: Any]] = dishes.map { dish in

            [
                "id": dish.id.uuidString,
                "name": dish.name,
                "category": dish.category,
                "grams": dish.outputQuantityInGrams,
                "instruction": dish.instruction,

                "ingredients": dish.ingredients.map {

                    [
                        "name": $0.name,
                        "grams": $0.grams
                    ]
                }
            ]
        }

        db.collection("menus")
            .document("main")
            .setData([
                "dishes": mapped,
                "updatedAt": Timestamp()
            ])
    }

    // MARK: - SEMI

    func uploadSemiProducts(
        _ semiProducts: [SemiFinishedProduct]
    ) {

        let mapped: [[String: Any]] = semiProducts.map { semi in

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
                "semiProducts": mapped,
                "updatedAt": Timestamp()
            ])
    }
}

