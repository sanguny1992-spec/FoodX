import SwiftUI
import UIKit

struct WorkScheduleView: View {
    
    @State private var showLinkAlert = false
    @State private var currentLink = ""
    
    @State private var employees: [WorkEmployee] = []
    @State private var name = ""
    
    private let storage = EmployeeStorage()
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                
                // HEADER
                
                HStack {
                    
                    Text("График работы")
                        .font(.largeTitle.bold())
                    
                    Spacer()
                    
                    Button {
                        
                        shareSchedule()
                        
                    } label: {
                        
                        Image(systemName: "square.and.arrow.up")
                            .font(.title2)
                            .foregroundColor(.orange)
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                // ADD EMPLOYEE
                
                HStack {
                    
                    TextField(
                        "ФИО сотрудника",
                        text: $name
                    )
                    .textFieldStyle(.roundedBorder)
                    
                    Button("Добавить") {
                        
                        guard !name.isEmpty else {
                            return
                        }
                        
                        employees.append(
                            WorkEmployee(name: name)
                        )
                        
                        storage.save(employees)
                        
                        name = ""
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                
                // LIST
                
                List {
                    
                    ForEach($employees) { $emp in
                        
                        NavigationLink {
                            
                            EmployeeCalendarView(
                                employee: $emp
                            ) {
                                
                                storage.save(employees)
                            }
                            
                        } label: {
                            
                            VStack(
                                alignment: .leading
                            ) {
                                
                                Text(emp.name)
                                    .font(.headline)
                                
                                Text("Открыть календарь")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            .onAppear {
                
                employees = storage.load()
            }
        }
        .alert(
            "Ссылка скопирована",
            isPresented: $showLinkAlert
        ) {
            
            Button("OK") { }
            
        } message: {
            
            Text(currentLink)
        }
    }
    
    // MARK: - SHARE
    
    func shareSchedule() {
        
        let service = ScheduleShareService()
        
        service.uploadSchedule(
            employees: employees
        ) { result in
            
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success(let link):
                    
                    currentLink = link
                    
                    UIPasteboard.general.string = link
                    
                    showLinkAlert = true
                    
                case .failure(let error):
                    
                    print(error.localizedDescription)
                }
            }
        }
    }
}
