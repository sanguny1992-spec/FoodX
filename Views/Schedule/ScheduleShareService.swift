import Foundation
import FirebaseFirestore

final class ScheduleShareService {

    private let db = Firestore.firestore()

    func uploadSchedule(
        employees: [WorkEmployee],
        completion: @escaping (Result<String, Error>) -> Void
    ) {

        let data = employees.map { employee in

            [
                "id": employee.id.uuidString,
                "name": employee.name,
                "monthDays": employee.monthDays
            ] as [String : Any]
        }

        db.collection("schedules")
            .document("main")
            .setData([

                "updatedAt": Timestamp(),
                "employees": data

            ]) { error in

                if let error {

                    completion(.failure(error))
                    return
                }

                completion(
                    .success(
                        "https://foodxnew.web.app/schedule/main"
                    )
                )
            }
    }
}
