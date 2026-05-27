import SwiftUI

struct EmployeesView: View {
    
    let restaurantId: String
    
    @State private var employees: [Employee] = []
    
    @State private var inviteCode = ""
    @State private var showInviteAlert = false
    
    @State private var showCreateEmployee = false
    
    private let inviteService = InviteService()
    
    private let service = EmployeeService()
    
    var body: some View {
        
        ZStack {
            
            Color.black
                .ignoresSafeArea()
            
            ScrollView {
                
                VStack(spacing: 14) {
                    
                    Text("Сотрудники")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                        .padding(.top)
                    
                    // MARK: - CREATE EMPLOYEE
                    
                    Button {
                        
                        showCreateEmployee = true
                        
                    } label: {
                        
                        HStack {
                            
                            Image(systemName: "person.badge.plus")
                            
                            Text("Создать сотрудника")
                                .fontWeight(.bold)
                        }
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 18)
                        )
                    }
                    .padding(.bottom, 10)
                    
                    // MARK: - EMPLOYEES
                    
                    ForEach(employees) { employee in
                        
                        VStack(
                            alignment: .leading,
                            spacing: 12
                        ) {
                            
                            HStack {
                                
                                VStack(
                                    alignment: .leading,
                                    spacing: 6
                                ) {
                                    
                                    Text(employee.name)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    
                                    Text(employee.email)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                Menu {
                                    
                                    Button("Employee") {
                                        
                                        service.updateRole(
                                            restaurantId: restaurantId,
                                            employeeId: employee.id,
                                            newRole: "employee"
                                        )
                                        
                                        loadEmployees()
                                    }
                                    
                                    Button("Chef") {
                                        
                                        service.updateRole(
                                            restaurantId: restaurantId,
                                            employeeId: employee.id,
                                            newRole: "chef"
                                        )
                                        
                                        loadEmployees()
                                    }
                                    
                                    Button("Admin") {
                                        
                                        service.updateRole(
                                            restaurantId: restaurantId,
                                            employeeId: employee.id,
                                            newRole: "admin"
                                        )
                                        
                                        loadEmployees()
                                    }
                                    
                                } label: {
                                    
                                    HStack(spacing: 4) {
                                        
                                        Text(employee.role.capitalized)
                                        
                                        Image(systemName: "chevron.down")
                                    }
                                    .foregroundColor(.orange)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(
                                        Color.orange.opacity(0.15)
                                    )
                                    .clipShape(
                                        RoundedRectangle(
                                            cornerRadius: 10
                                        )
                                    )
                                }
                            }
                            
                            // STATUS
                            
                            Text(employee.status.capitalized)
                                .foregroundColor(
                                    employee.status == "approved"
                                    ? .green
                                    : employee.status == "blocked"
                                    ? .red
                                    : .orange
                                )
                                .font(.caption.bold())
                            
                            // ACTIONS
                            
                            HStack(spacing: 10) {
                                
                                if employee.status == "pending" {
                                    
                                    Button {
                                        
                                        service.approveEmployee(
                                            restaurantId: restaurantId,
                                            employeeId: employee.id
                                        )
                                        
                                        loadEmployees()
                                        
                                    } label: {
                                        
                                        Text("Approve")
                                            .font(.caption.bold())
                                            .foregroundColor(.black)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .background(Color.green)
                                            .clipShape(Capsule())
                                    }
                                }
                                
                                if employee.status == "approved" {
                                    
                                    Button {
                                        
                                        service.blockEmployee(
                                            restaurantId: restaurantId,
                                            employeeId: employee.id
                                        )
                                        
                                        loadEmployees()
                                        
                                    } label: {
                                        
                                        Text("Block")
                                            .font(.caption.bold())
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .background(Color.red)
                                            .clipShape(Capsule())
                                    }
                                }
                                
                                if employee.status == "blocked" {
                                    
                                    Button {
                                        
                                        service.unblockEmployee(
                                            restaurantId: restaurantId,
                                            employeeId: employee.id
                                        )
                                        
                                        loadEmployees()
                                        
                                    } label: {
                                        
                                        Text("Unblock")
                                            .font(.caption.bold())
                                            .foregroundColor(.black)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .background(Color.orange)
                                            .clipShape(Capsule())
                                    }
                                }
                                
                                Spacer()
                                
                                Button {
                                    
                                    service.deleteEmployee(
                                        restaurantId: restaurantId,
                                        employeeId: employee.id
                                    )
                                    
                                    loadEmployees()
                                    
                                } label: {
                                    
                                    Image(systemName: "trash.fill")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            Color.white.opacity(0.05)
                        )
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 18
                            )
                        )
                    }
                }
                .padding()
            }
        }
        .preferredColorScheme(.dark)
        
        // CREATE EMPLOYEE
        
        .fullScreenCover(isPresented: $showCreateEmployee) {
            
            CreateEmployeeView(
                restaurantId: restaurantId
            )
        }
        
        // INVITE ALERT
        
        .alert(
            "Код приглашения",
            isPresented: $showInviteAlert
        ) {
            
            Button("OK") { }
            
        } message: {
            
            Text(inviteCode)
        }
        
        // TOOLBAR
        
        .toolbar {
            
            ToolbarItem(placement: .topBarTrailing) {
                
                Button {
                    
                    inviteService.createInvite(
                        restaurantId: restaurantId
                    ) { result in
                        
                        switch result {
                            
                        case .success(let code):
                            
                            DispatchQueue.main.async {
                                
                                inviteCode = code
                                showInviteAlert = true
                            }
                            
                        case .failure(let error):
                            
                            print(error.localizedDescription)
                        }
                    }
                    
                } label: {
                    
                    Image(systemName: "link.badge.plus")
                        .foregroundColor(.orange)
                }
            }
        }
        
        .onAppear {
            
            loadEmployees()
        }
    }
    
    // MARK: - LOAD
    
    func loadEmployees() {
        
        service.fetchEmployees(
            restaurantId: restaurantId
        ) { employees in
            
            DispatchQueue.main.async {
                
                self.employees = employees
            }
        }
    }
}
