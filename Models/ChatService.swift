import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

final class ChatService: ObservableObject {
    
    @Published var messages: [ChatMessage] = []
    
    private let db = Firestore.firestore()
    
    private var listener: ListenerRegistration?
    
    // MARK: - LISTEN
    
    func listen(
        restaurantId: String
    ) {
        
        listener?.remove()
        
        listener = db.collection("restaurants")
            .document(restaurantId)
            .collection("chat")
            .order(by: "createdAt")
            .addSnapshotListener { snapshot, error in
                
                guard let docs = snapshot?.documents else {
                    return
                }
                
                DispatchQueue.main.async {
                    
                    self.messages = docs.compactMap {
                        try? $0.data(as: ChatMessage.self)
                    }
                }
            }
    }
    
    // MARK: - SEND
    
    func send(
        restaurantId: String,
        text: String
    ) {
        
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        // ИЩЕМ СОТРУДНИКА
        
        db.collection("restaurants")
            .document(restaurantId)
            .collection("employees")
            .document(uid)
            .getDocument { snapshot, error in
                
                let employeeName =
                    snapshot?.data()?["name"] as? String
                    ?? "Unknown"
                
                let data: [String: Any] = [
                    "sender": employeeName,
                    "text": text,
                    "createdAt": Timestamp(date: Date())
                ]
                
                self.db.collection("restaurants")
                    .document(restaurantId)
                    .collection("chat")
                    .addDocument(data: data)
            }
    }
}
