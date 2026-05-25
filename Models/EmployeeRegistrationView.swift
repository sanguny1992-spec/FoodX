import SwiftUI
import FirebaseFirestore

struct EmployeeRegistrationView: View {

    let restaurantId: String

    @Environment(\.dismiss) var dismiss

    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var role = "employee"

    @State private var showAlert = false
    @State private var alertText = ""

    let roles = [
        "employee",
        "manager",
        "admin"
    ]

    var body: some View {

        NavigationStack {

            ZStack {

                Color.black
                    .ignoresSafeArea()

                ScrollView {

                    VStack(spacing: 18) {

                        Text("Создать сотрудника")
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)

                        Group {

                            TextField("Имя", text: $name)

                            TextField("Email", text: $email)

                            SecureField("Пароль", text: $password)

                        }
                        .padding()
                        .background(
                            Color.white.opacity(0.08)
                        )
                        .clipShape(
                            RoundedRectangle(cornerRadius: 16)
                        )
                        .foregroundColor(.white)

                        Picker("Роль", selection: $role) {

                            ForEach(roles, id: \.self) { item in

                                Text(item)
                            }
                        }
                        .pickerStyle(.segmented)

                        Button {

                            createEmployee()

                        } label: {

                            Text("Создать")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    LinearGradient(
                                        colors: [.green, .blue],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 18)
                                )
                        }
                    }
                    .padding()
                }
            }
            .preferredColorScheme(.dark)
            .toolbar {

                ToolbarItem(placement: .topBarTrailing) {

                    Button("Закрыть") {

                        dismiss()
                    }
                }
            }
            .alert(
                "FoodX",
                isPresented: $showAlert
            ) {

                Button("OK") {

                    if alertText == "Сотрудник создан 🚀" {

                        dismiss()
                    }
                }

            } message: {

                Text(alertText)
            }
        }
    }

    // MARK: - CREATE

    func createEmployee() {

        guard !name.isEmpty else { return }
        guard !email.isEmpty else { return }
        guard !password.isEmpty else { return }

        let db = Firestore.firestore()

        let employeeId = UUID().uuidString

        db.collection("restaurants")
            .document(restaurantId)
            .collection("employees")
            .document(employeeId)
            .setData([

                "id": employeeId,
                "name": name,
                "email": email,
                "password": password,
                "role": role,
                "status": "approved",
                "createdAt": Timestamp()

            ]) { error in

                if let error {

                    alertText = error.localizedDescription

                } else {

                    alertText = "Сотрудник создан 🚀"
                }

                showAlert = true
            }
    }
}
