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
    func fetchEmployees(
        restaurantId: String,
        completion: @escaping ([Employee]) -> Void
    ) {

        db.collection("restaurants")
            .document(restaurantId)
            .collection("employees")
            .getDocuments { snapshot, error in

                if let error {

                    print(error.localizedDescription)
                    completion([])
                    return
                }

                guard let docs = snapshot?.documents else {
                    completion([])
                    return
                }

                let employees = docs.compactMap {

                    try? $0.data(as: Employee.self)
                }

                completion(employees)
            }
    }
}
