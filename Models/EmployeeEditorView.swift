import SwiftUI
import FirebaseFirestore

struct EmployeeEditorView: View {
    
    let restaurantId: String
    
    let employee: EmployeeModel
    
    @Environment(\.dismiss) var dismiss
    
    @State private var role: String
    @State private var status: String
    
    private let db = Firestore.firestore()
    
    init(
        restaurantId: String,
        employee: EmployeeModel
    ) {
        self.restaurantId = restaurantId
        self.employee = employee
        
        _role = State(initialValue: employee.role)
        _status = State(initialValue: employee.status)
    }
    
    let roles = [
        "owner",
        "admin",
        "chef",
        "staff",
        "viewer"
    ]
    
    let statuses = [
        "approved",
        "blocked"
    ]
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                Color.black
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    
                    VStack(spacing: 10) {
                        
                        Text(employee.name)
                            .font(.title.bold())
                            .foregroundColor(.white)
                        
                        Text(employee.email)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    VStack(spacing: 18) {
                        
                        Picker(
                            "Роль",
                            selection: $role
                        ) {
                            
                            ForEach(roles, id: \.self) {
                                
                                Text($0)
                            }
                        }
                        .pickerStyle(.menu)
                        
                        Picker(
                            "Статус",
                            selection: $status
                        ) {
                            
                            ForEach(statuses, id: \.self) {
                                
                                Text($0)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    .padding()
                    .background(
                        Color.white.opacity(0.06)
                    )
                    .clipShape(
                        RoundedRectangle(cornerRadius: 22)
                    )
                    
                    Button {
                        
                        save()
                        
                    } label: {
                        
                        Text("Сохранить")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
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
                    }
                    
                    Button {
                        
                        deleteEmployee()
                        
                    } label: {
                        
                        Text("Удалить сотрудника")
                            .foregroundColor(.red)
                    }
                    
                    Spacer()
                }
                .padding()
            }
        }
    }
    
    // MARK: - SAVE
    
    func save() {
        
        guard let id = employee.id else {
            return
        }
        
        db.collection("restaurants")
            .document(restaurantId)
            .collection("employees")
            .document(id)
            .updateData([
                "role": role,
                "status": status
            ])
        
        dismiss()
    }
    
    // MARK: - DELETE
    
    func deleteEmployee() {
        
        guard let id = employee.id else {
            return
        }
        
        db.collection("restaurants")
            .document(restaurantId)
            .collection("employees")
            .document(id)
            .delete()
        
        dismiss()
    }
}
