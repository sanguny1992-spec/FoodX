import SwiftUI
import FirebaseAuth

struct EmployeeRegisterView: View {
    
    @ObservedObject var auth: AuthManager
    
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var restaurantCode = ""
    
    @State private var errorText = ""
    @State private var showError = false
    
    private let restaurantService =
        RestaurantService()
    
    private let employeeService =
        EmployeeService()
    
    var body: some View {
        
        ZStack {
            
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                
                Text("Регистрация сотрудника")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                TextField(
                    "Имя",
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
                
                TextField(
                    "Код ресторана",
                    text: $restaurantCode
                )
                .padding()
                .background(Color.white)
                .clipShape(
                    RoundedRectangle(cornerRadius: 14)
                )
                
                Button {
                    
                    registerEmployee()
                    
                } label: {
                    
                    Text("Отправить запрос")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 16)
                        )
                }
                
                if showError {
                    
                    Text(errorText)
                        .foregroundColor(.red)
                }
            }
            .padding()
        }
    }
    
    func registerEmployee() {
        
        restaurantService.fetchRestaurantByCode(
            code: restaurantCode
        ) { restaurant in
            
            guard let restaurant else {
                
                DispatchQueue.main.async {
                    
                    errorText = "Ресторан не найден"
                    showError = true
                }
                
                return
            }
            
            Auth.auth().createUser(
                withEmail: email,
                password: password
            ) { result, error in
                
                if let error {
                    
                    DispatchQueue.main.async {
                        
                        errorText = error.localizedDescription
                        showError = true
                    }
                    
                    return
                }
                
                employeeService.createEmployee(
                    name: name,
                    email: email,
                    restaurantId: restaurant.id,
                    role: "employee"
                )
                
                DispatchQueue.main.async {
                    
                    auth.user = result?.user
                }
            }
        }
    }
}
