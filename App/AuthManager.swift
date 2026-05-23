import Foundation
import FirebaseAuth
import Combine

final class AuthManager: ObservableObject {
    
    @Published var user: User?
    
    init() {
        
        self.user = Auth.auth().currentUser
    }
    
    func logout() {
        
        do {
            
            try Auth.auth().signOut()
            
            self.user = nil
            
        } catch {
            
            print(error.localizedDescription)
        }
    }
    func signOut() {

        do {

            try Auth.auth().signOut()
            self.user = nil

        } catch {

            print(error.localizedDescription)
        }
    }
}
