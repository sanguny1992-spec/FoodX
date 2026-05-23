import Foundation
import FirebaseFirestore

final class InviteService {
    
    private let db = Firestore.firestore()
    
    // СОЗДАТЬ КОД
    
    func createInvite(
        restaurantId: String,
        completion: @escaping(Result<String, Error>) -> Void
    ) {
        
        let inviteId = UUID().uuidString
        
        let code =
        String(UUID().uuidString.prefix(6))
            .uppercased()
        
        let invite = InviteCode(
            id: inviteId,
            code: code,
            restaurantId: restaurantId
        )
        
        do {
            
            try db
                .collection("invites")
                .document(inviteId)
                .setData(from: invite)
            
            completion(.success(code))
            
        } catch {
            
            completion(.failure(error))
        }
    }
    
    // ПРОВЕРКА КОДА
    
    func validateInvite(
        code: String,
        completion: @escaping(Result<InviteCode, Error>) -> Void
    ) {
        
        db.collection("invites")
            .whereField("code", isEqualTo: code)
            .getDocuments { snapshot, error in
                
                if let error {
                    completion(.failure(error))
                    return
                }
                
                guard
                    let doc = snapshot?.documents.first
                else {
                    completion(
                        .failure(
                            NSError(
                                domain: "invite",
                                code: 404
                            )
                        )
                    )
                    return
                }
                
                do {
                    
                    let invite =
                    try doc.data(as: InviteCode.self)
                    
                    completion(.success(invite))
                    
                } catch {
                    
                    completion(.failure(error))
                }
            }
    }
}
