import Foundation
import Combine
import FirebaseAuth

final class AuthManager: ObservableObject {
    
    @Published var user: User?
    
    init() {
        self.user = Auth.auth().currentUser
    }
    
    // LOGIN
    
    func signIn(
        email: String,
        password: String,
        completion: @escaping (String?) -> Void
    ) {
        
        Auth.auth().signIn(
            withEmail: email,
            password: password
        ) { result, error in
            
            if let error {
                completion(error.localizedDescription)
                return
            }
            
            self.user = result?.user
            completion(nil)
        }
    }
    
    // REGISTER
    
    func register(
        email: String,
        password: String,
        completion: @escaping (String?) -> Void
    ) {
        
        Auth.auth().createUser(
            withEmail: email,
            password: password
        ) { result, error in
            
            if let error {
                completion(error.localizedDescription)
                return
            }
            
            self.user = result?.user
            completion(nil)
        }
    }
    
    // LOGOUT
    
    func signOut() {
        
        do {
            
            try Auth.auth().signOut()
            self.user = nil
            
        } catch {
            
            print(error.localizedDescription)
        }
    }
}
