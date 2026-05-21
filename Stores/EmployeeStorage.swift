import Foundation

class EmployeeStorage {

    private let key = "employees_key"

    func save(_ employees: [WorkEmployee]) {

        if let data = try? JSONEncoder().encode(employees) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func load() -> [WorkEmployee] {

        guard let data = UserDefaults.standard.data(forKey: key),
              let employees = try? JSONDecoder().decode([WorkEmployee].self, from: data)
        else {
            return []
        }

        return employees
    }
}
