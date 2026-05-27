import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct CreateEmployeeView: View {
    
    let restaurantId: String
    
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    
    @State private var role = "staff"
    
    @State private var loading = false
    
    private let db = Firestore.firestore()
    
    let roles = [
        "owner",
        "admin",
        "chef",
        "staff",
        "viewer"
    ]
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                Image("FoodX")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                Color.black.opacity(0.7)
                    .ignoresSafeArea()
                
                VStack(spacing: 18) {
                    
                    glassField(
                        "Имя",
                        text: $name
                    )
                    
                    glassField(
                        "Email",
                        text: $email
                    )
                    
                    glassField(
                        "Пароль",
                        text: $password
                    )
                    
                    Picker(
                        "Роль",
                        selection: $role
                    ) {
                        
                        ForEach(roles, id: \.self) {
                            
                            Text($0)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    Button {
                        
                        createEmployee()
                        
                    } label: {
                        
                        if loading {
                            
                            ProgressView()
                                .tint(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                            
                        } else {
                            
                            Text("Создать сотрудника")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                    }
                    .background(
                        LinearGradient(
                            colors: [.green, .mint],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(
                        RoundedRectangle(cornerRadius: 18)
                    )
                    
                    Spacer()
                }
                .padding()
            }
        }
    }
    
    // MARK: - CREATE
    
    func createEmployee() {
        
        loading = true
        
        Auth.auth().createUser(
            withEmail: email,
            password: password
        ) { result, error in
            
            if let error {
                
                print(error.localizedDescription)
                loading = false
                return
            }
            
            guard let uid = result?.user.uid else {
                
                loading = false
                return
            }
            
            let data: [String: Any] = [
                "id": uid,
                "name": name,
                "email": email,
                "restaurantId": restaurantId,
                "role": role,
                "status": "approved",
                "createdAt": Timestamp()
            ]
            
            db.collection("restaurants")
                .document(restaurantId)
                .collection("employees")
                .document(uid)
                .setData(data) { error in
                    
                    loading = false
                    
                    if let error {
                        
                        print(error.localizedDescription)
                        return
                    }
                    
                    dismiss()
                }
        }
    }
    // MARK: - UI

    @ViewBuilder
    func glassField(
        _ placeholder: String,
        text: Binding<String>
    ) -> some View {
        
        TextField(
            placeholder,
            text: text
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
}
