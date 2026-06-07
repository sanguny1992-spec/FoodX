import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine

final class AuthManager: ObservableObject {

    @Published var user: User?

    @Published var userId = ""

    @Published var employeeName = ""

    @Published var restaurantId = ""
    
    @Published var employeeStatus = "pending"

    @Published var employeeRole = "employee"
    
    @Published var restaurantName = ""

    private let db = Firestore.firestore()

    init() {

        self.user = Auth.auth().currentUser

        if let currentUser = self.user {
            
            print("CURRENT USER UID:", currentUser.uid)
            

            self.userId = currentUser.uid

            loadEmployeeData(
                uid: currentUser.uid
            )
        }
    }
    func loadRestaurant(
        restaurantId: String
    ) {

        db.collection("restaurants")
            .document(restaurantId)
            .getDocument { snapshot, error in

                guard let data =
                    snapshot?.data()
                else {
                    return
                }

                DispatchQueue.main.async {

                    self.restaurantName =
                        data["name"] as? String ?? ""
                }
            }
    }
    func loadEmployeeData(uid: String) {

        print("SEARCH UID:", uid)

        db.collectionGroup("employees")
            .whereField("id", isEqualTo: uid)
            .getDocuments { snapshot, error in

                if let error {

                    print("ERROR:", error.localizedDescription)
                    return
                }

                print("FOUND DOCS:",
                      snapshot?.documents.count ?? 0)

                guard let document =
                    snapshot?.documents.first
                else {

                    print("EMPLOYEE NOT FOUND")
                    return
                }

                let data = document.data()

                print("EMPLOYEE DATA:", data)

                DispatchQueue.main.async {

                    self.employeeName =
                        data["name"] as? String
                        ?? "Сотрудник"

                    self.employeeStatus =
                        data["status"] as? String
                        ?? "pending"

                    self.employeeRole =
                        data["role"] as? String
                        ?? "employee"

                    self.restaurantId =
                        data["restaurantId"] as? String
                        ?? ""
                    
                    self.loadRestaurant(
                        restaurantId: self.restaurantId
                    )

                    print("NAME:", self.employeeName)
                    print("ROLE:", self.employeeRole)
                    print("STATUS:", self.employeeStatus)
                    print("RESTAURANT:", self.restaurantId)
                }
            }
    }

    func signOut() {

        do {

            try Auth.auth().signOut()

            self.user = nil
            self.userId = ""
            self.employeeName = ""

        } catch {

            print(error.localizedDescription)
        }
    }

    func logout() {

        signOut()
    }
}
