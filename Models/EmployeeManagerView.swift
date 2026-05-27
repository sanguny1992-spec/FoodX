import SwiftUI
import FirebaseFirestore

struct EmployeeManagerView: View {
    
    let restaurantId: String
    
    @State private var employees: [EmployeeModel] = []
    @State private var showCreateEmployee = false
    @State private var selectedEmployee: EmployeeModel?
    
    private let db = Firestore.firestore()
    
    var body: some View {
        
        ZStack {
            
            // BACKGROUND
            
            Image("FoodX")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            Color.black.opacity(0.65)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                // HEADER
                
                HStack {
                    
                    VStack(alignment: .leading, spacing: 4) {
                        
                        Text("Сотрудники")
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                        
                        Text("Управление персоналом")
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    Button {
                        
                        showCreateEmployee = true
                        
                    } label: {
                        
                        ZStack {
                            
                            Circle()
                                .fill(.green.opacity(0.2))
                                .frame(width: 50, height: 50)
                            
                            Image(systemName: "plus")
                                .font(.title2.bold())
                                .foregroundColor(.green)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                // EMPLOYEES
                
                ScrollView(showsIndicators: false) {
                    
                    VStack(spacing: 14) {
                        
                        ForEach(employees) { employee in
                            
                            employeeCard(employee)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 40)
                }
            }
        }
        .preferredColorScheme(.dark)
        
        .onAppear {
            
            fetchEmployees()
        }
        .toolbar {

            ToolbarItem(placement: .topBarTrailing) {

                Button {

                    showCreateEmployee = true

                } label: {

                    Image(systemName: "person.badge.plus")
                        .foregroundColor(.green)
                }
            }
        }
        
        // CREATE
        
        .fullScreenCover(isPresented: $showCreateEmployee) {
            
            CreateEmployeeView(
                restaurantId: restaurantId
            )
        }
        
        // EDIT
        
        .sheet(item: $selectedEmployee) { employee in
            
            EmployeeEditorView(
                restaurantId: restaurantId,
                employee: employee
            )
        }
    }
    
    // MARK: - CARD
    
    @ViewBuilder
    func employeeCard(_ employee: EmployeeModel) -> some View {
        
        HStack(spacing: 14) {
            
            ZStack {
                
                Circle()
                    .fill(Color.white.opacity(0.08))
                    .frame(width: 56, height: 56)
                
                Image(systemName: "person.fill")
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                
                Text(employee.name)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(employee.email)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                
                HStack {
                    
                    Text(employee.role.uppercased())
                        .font(.caption.bold())
                        .foregroundColor(.orange)
                    
                    Circle()
                        .fill(
                            employee.status == "approved"
                            ? Color.green
                            : Color.red
                        )
                        .frame(width: 8, height: 8)
                    
                    Text(employee.status)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            
            Spacer()
            
            Button {
                
                selectedEmployee = employee
                
            } label: {
                
                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Color.white.opacity(0.08))
                    .clipShape(Circle())
            }
        }
        .padding()
        .background(.ultraThinMaterial.opacity(0.9))
        .clipShape(
            RoundedRectangle(cornerRadius: 24)
        )
    }
    
    // MARK: - FETCH
    
    func fetchEmployees() {
        
        db.collection("restaurants")
            .document(restaurantId)
            .collection("employees")
            .addSnapshotListener { snapshot, error in
                
                guard let docs = snapshot?.documents else {
                    return
                }
                
                self.employees = docs.compactMap {
                    try? $0.data(as: EmployeeModel.self)
                }
            }
    }
}
