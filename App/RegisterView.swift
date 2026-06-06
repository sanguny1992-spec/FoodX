import SwiftUI
import FirebaseAuth
import FirebaseFirestore



struct RegisterView: View {
    
    @ObservedObject var auth: AuthManager
    
    @State private var restaurantName = ""
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    
    private let restaurantService =
        RestaurantService()
    
    private let employeeService =
        EmployeeService()
    
    var body: some View {
        
        ZStack {
            
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                
                Text("Регистрация")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                TextField(
                    "Название заведения",
                    text: $restaurantName
                )
                .padding()
                .background(Color.white)
                .clipShape(
                    RoundedRectangle(cornerRadius: 14)
                )
                
                TextField(
                    "Ваше имя",
                    text: $name
                )
                .padding()
                .background(Color.white)
                .clipShape(
                    RoundedRectangle(cornerRadius: 14)
                )
                
                TextField(
                    "Email",
                    text: $email
                )
                .padding()
                .background(Color.white)
                .clipShape(
                    RoundedRectangle(cornerRadius: 14)
                )
                
                SecureField(
                    "Пароль",
                    text: $password
                )
                .padding()
                .background(Color.white)
                .clipShape(
                    RoundedRectangle(cornerRadius: 14)
                )
                
                Button {
                    
                    register()
                    
                } label: {
                    
                    Text("Создать аккаунт")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 16)
                        )
                }
            }
            .padding()
        }
    }
    
    func register() {
        
        Auth.auth()
            .createUser(
                withEmail: email,
                password: password
            ) { result, error in
                
                if let error {
                    
                    print(error.localizedDescription)
                    return
                }
                
                restaurantService
                    .createRestaurant(
                        name: restaurantName
                    ) { restaurantId in
                        
                        guard let restaurantId else {
                            return
                        }
                        
                        employeeService
                            .createEmployee(
                                name: name,
                                email: email,
                                restaurantId: restaurantId,
                                role: "owner"
                            )
                        
                        DispatchQueue.main.async {
                            
                            auth.user =
                                result?.user
                        }
                    }
            }
    }
}
