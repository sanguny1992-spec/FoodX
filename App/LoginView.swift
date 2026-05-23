import SwiftUI

struct LoginView: View {
    
    @ObservedObject var auth: AuthManager
    
    @State private var email = ""
    @State private var password = ""
    
    @State private var isRegister = false
    
    @State private var errorText = ""
    
    var body: some View {
        
        ZStack {
            
            Image("FoodX")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            Color.black.opacity(0.85)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                Spacer()
                
                Text("FoodX")
                    .font(.system(size: 42, weight: .bold))
                    .foregroundColor(.white)
                
                Text(
                    isRegister
                    ? "Регистрация сотрудника"
                    : "Вход сотрудника"
                )
                .foregroundColor(.gray)
                
                VStack(spacing: 14) {
                    
                    TextField(
                        "Email",
                        text: $email
                    )
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding()
                    .background(
                        Color.white.opacity(0.08)
                    )
                    .clipShape(
                        RoundedRectangle(cornerRadius: 18)
                    )
                    .foregroundColor(.white)
                    
                    SecureField(
                        "Пароль",
                        text: $password
                    )
                    .padding()
                    .background(
                        Color.white.opacity(0.08)
                    )
                    .clipShape(
                        RoundedRectangle(cornerRadius: 18)
                    )
                    .foregroundColor(.white)
                }
                
                if !errorText.isEmpty {
                    
                    Text(errorText)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                Button {
                    
                    if isRegister {
                        
                        auth.register(
                            email: email,
                            password: password
                        ) { error in
                            
                            if let error {
                                errorText = error
                            }
                        }
                        
                    } else {
                        
                        auth.signIn(
                            email: email,
                            password: password
                        ) { error in
                            
                            if let error {
                                errorText = error
                            }
                        }
                    }
                    
                } label: {
                    
                    Text(
                        isRegister
                        ? "Создать аккаунт"
                        : "Войти"
                    )
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 18)
                    )
                }
                
                Button {
                    
                    isRegister.toggle()
                    errorText = ""
                    
                } label: {
                    
                    Text(
                        isRegister
                        ? "Уже есть аккаунт?"
                        : "Создать аккаунт"
                    )
                    .foregroundColor(.white)
                }
                
                Spacer()
            }
            .padding()
        }
        .preferredColorScheme(.dark)
    }
}
