import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine

final class AuthManager: ObservableObject {

    @Published var user: User?

    @Published var userId = ""

    @Published var employeeName = ""

    private let db =
        Firestore.firestore()

    init() {

        self.user = Auth.auth().currentUser

        if let currentUser = self.user {

            self.userId = currentUser.uid

            loadEmployeeData(
                uid: currentUser.uid
            )
        }
    }

    // MARK: - LOAD EMPLOYEE

    func loadEmployeeData(uid: String) {

        db.collection("restaurants")
            .document("6A0C27E2-2B87-4EB3-9576-6AC17129727D")
            .collection("employees")
            .document(uid)
            .getDocument { snapshot, error in

                guard let data = snapshot?.data()
                else {
                    return
                }

                DispatchQueue.main.async {

                    self.employeeName =
                        data["fullName"] as? String
                        ??
                        data["name"] as? String
                        ??
                        "Сотрудник"
                }
            }
    }

    // MARK: - SIGN OUT

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

    // MARK: - LOGOUT

    func logout() {

        signOut()
    }
}
