import SwiftUI
import Firebase
import FirebaseAuth

@main
struct FoodXnewApp: App {
    
    @StateObject var auth = AuthManager()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        
        WindowGroup {
            
            if auth.user == nil {

                LoginView(auth: auth)

            } else if auth.employeeStatus == "pending" {

                PendingView()

            } else if auth.employeeStatus == "blocked" {

                BlockedView()

            } else {

                ContentView()
                    .environmentObject(auth)
            }
        }
    }
}
