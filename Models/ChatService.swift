import Foundation
import FirebaseFirestore
import Combine

final class ChatService: ObservableObject {

    @Published var messages: [ChatMessage] = []

    private let db = Firestore.firestore()

    private var listener: ListenerRegistration?

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

    func send(
        restaurantId: String,
        sender: String,
        senderId: String,
        text: String
    ) {

        guard !text.isEmpty else {
            return
        }

        let data: [String: Any] = [

            "sender": sender,

            "senderId": senderId,

            "text": text,

            "createdAt": Timestamp()
        ]

        db.collection("restaurants")
            .document(restaurantId)
            .collection("chat")
            .addDocument(data: data)
    }
}
