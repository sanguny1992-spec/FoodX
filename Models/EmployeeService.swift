import Foundation
import FirebaseFirestore
import FirebaseAuth

final class EmployeeService {

    private let db = Firestore.firestore()
    
    
    func updateRole(
        restaurantId: String,
        employeeId: String,
        newRole: String
    ) {
        
        db.collection("restaurants")
            .document(restaurantId)
            .collection("employees")
            .document(employeeId)
            .updateData([
                "role": newRole
            ])
    }
 
    func createEmployee(
        name: String,
        email: String,
        restaurantId: String,
        role: String = "employee"
    ) {

        let employee = Employee(
            id: Auth.auth().currentUser?.uid ?? "",
            name: name,
            email: email,
            restaurantId: restaurantId,
            role: role,
            status: "pending",
            createdAt: Date()
        
        )

        do {

            try db
                .collection("restaurants")
                .document(restaurantId)
                .collection("employees")
                .document(employee.id)
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
    func approveEmployee(
        restaurantId: String,
        employeeId: String
    ) {
        
        db.collection("restaurants")
            .document(restaurantId)
            .collection("employees")
            .document(employeeId)
            .updateData([
                "status": "approved"
            ])
    }
    func blockEmployee(
        restaurantId: String,
        employeeId: String
    ) {
        
        db.collection("restaurants")
            .document(restaurantId)
            .collection("employees")
            .document(employeeId)
            .updateData([
                "status": "blocked"
            ])
    }

    func unblockEmployee(
        restaurantId: String,
        employeeId: String
    ) {
        
        db.collection("restaurants")
            .document(restaurantId)
            .collection("employees")
            .document(employeeId)
            .updateData([
                "status": "approved"
            ])
    }

    func deleteEmployee(
        restaurantId: String,
        employeeId: String
    ) {
        
        db.collection("restaurants")
            .document(restaurantId)
            .collection("employees")
            .document(employeeId)
            .delete()
    }
}
