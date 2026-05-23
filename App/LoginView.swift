import SwiftUI
import FirebaseAuth

struct LoginView: View {
    
    @ObservedObject var auth: AuthManager
    
    @State private var email = ""
    @State private var password = ""
    
    @State private var showRegister = false
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                Color.black
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    
                    Spacer()
                    
                    Text("FoodX")
                        .font(.system(size: 42, weight: .bold))
                        .foregroundColor(.orange)
                    
                    Text("Вход")
                        .font(.title.bold())
                        .foregroundColor(.white)
                    
                    TextField(
                        "Email",
                        text: $email
                    )
                    .padding()
                    .background(Color.white)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 14)
                    )
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    
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
                        
                        login()
                        
                    } label: {
                        
                        Text("Войти")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 16)
                            )
                    }
                    
                    Button {
                        
                        showRegister = true
                        
                    } label: {
                        
                        Text("Создать аккаунт")
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationDestination(
                isPresented: $showRegister
            ) {
                
                RegisterView(auth: auth)
            }
        }
    }
    
    func login() {
        
        Auth.auth().signIn(
            withEmail: email,
            password: password
        ) { result, error in
            
            if let error {
                
                print(error.localizedDescription)
                return
            }
            
            DispatchQueue.main.async {
                
                auth.user = result?.user
            }
        }
    }
}
