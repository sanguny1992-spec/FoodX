import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

final class CurrentEmployeeManager: ObservableObject {
    
    @Published var currentEmployee: Employee?
    
    private let db = Firestore.firestore()
    
    func fetchCurrentEmployee() {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        db.collection("restaurants")
            .getDocuments { snapshot, error in
                
                if let error {
                    
                    print(error.localizedDescription)
                    return
                }
                
                guard let restaurants = snapshot?.documents else {
                    return
                }
                
                for restaurant in restaurants {
                    
                    let restaurantId = restaurant.documentID
                    
                    self.db.collection("restaurants")
                        .document(restaurantId)
                        .collection("employees")
                        .document(uid)
                        .getDocument { snapshot, error in
                            
                            if let employee =
                                try? snapshot?.data(as: Employee.self) {
                                
                                DispatchQueue.main.async {
                                    
                                    self.currentEmployee = employee
                                }
                            }
                        }
                }
            }
    }
}
