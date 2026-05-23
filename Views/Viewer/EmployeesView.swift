import SwiftUI

struct EmployeesView: View {
    
    let restaurantId: String
    
    @State private var employees: [Employee] = []
    
    private let service =
        EmployeeService()
    
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
                    
                    ForEach(employees) { employee in
                        
                        VStack(
                            alignment: .leading,
                            spacing: 8
                        ) {
                            
                            HStack {
                                
                                Text(employee.name)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Text(employee.role)
                                    .foregroundColor(.orange)
                            }
                            
                            Text(employee.email)
                                .foregroundColor(.gray)
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
        .onAppear {
            
            loadEmployees()
        }
    }
    
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
