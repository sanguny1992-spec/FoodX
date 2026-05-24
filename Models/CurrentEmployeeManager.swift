import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine

final class CurrentEmployeeManager:
ObservableObject {
    
    @Published var employee: Employee?
    
    private let db = Firestore.firestore()
    
    func loadEmployee(
        restaurantId: String
    ) {
        
        guard let uid =
            Auth.auth().currentUser?.uid
        else {
            return
        }
        
        db.collection("restaurants")
            .document(restaurantId)
            .collection("employees")
            .document(uid)
            .getDocument { snapshot, error in
                
                if let error {
                    
                    print(error.localizedDescription)
                    return
                }
                
                guard let snapshot else {
                    return
                }
                
                do {
                    
                    let employee =
                        try snapshot.data(
                            as: Employee.self
                        )
                    
                    DispatchQueue.main.async {
                        
                        self.employee =
                            employee
                    }
                    
                } catch {
                    
                    print(error.localizedDescription)
                }
            }
    }
}
