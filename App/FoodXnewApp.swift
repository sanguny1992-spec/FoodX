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

            ContentView()
        }
    }
}
