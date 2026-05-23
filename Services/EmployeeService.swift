import Foundation
import FirebaseFirestore

final class EmployeeService {

    private let db = Firestore.firestore()

    func createEmployee(
        name: String,
        email: String,
        password: String,
        restaurantId: String,
        role: String = "employee"
    ) {

        let employee = Employee(
            id: UUID(),
            name: name,
            email: email,
            password: password,
            restaurantId: restaurantId,
            role: role
        )

        do {

            try db
                .collection("restaurants")
                .document(restaurantId)
                .collection("employees")
                .document(employee.id.uuidString)
                .setData(from: employee)

        } catch {

            print(error.localizedDescription)
        }
    }
}
