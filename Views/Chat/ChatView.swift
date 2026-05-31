import SwiftUI
import FirebaseFirestore

struct ChatView: View {

    let restaurantId: String

    @EnvironmentObject var auth: AuthManager

    @StateObject private var service =
        ChatService()

    @State private var text = ""
    @EnvironmentObject var store: InventoryStore
    
    func isWriteOffRequest(_ text: String) -> Bool {

        let lower = text.lowercased()

        return lower.contains("списать")
            || lower.contains("спишите")
            || lower.contains("списание")
    }
    func processWriteOff(_ text: String) {

        let lower = text.lowercased()

        let words = lower.components(separatedBy: " ")

        guard let amountWord = words.first(where: {
            Double($0) != nil
        }) else {
            return
        }

        guard let amount = Double(amountWord) else {
            return
        }

        var productName = lower

        productName = productName
            .replacingOccurrences(of: "списать", with: "")
            .replacingOccurrences(of: "спишите", with: "")
            .replacingOccurrences(of: amountWord, with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard let index = store.products.firstIndex(where: {

            $0.name.lowercased().contains(productName)

        }) else {

            print("Продукт не найден: \(productName)")
            return
        }

        store.products[index].quantityInGrams -= amount

        if store.products[index].quantityInGrams < 0 {

            store.products[index].quantityInGrams = 0
        }

        store.save()

        print("Списано \(amount) г из \(store.products[index].name)")
    }
    var body: some View {

        VStack {

            ScrollView {

                LazyVStack(
                    spacing: 14
                ) {

                    ForEach(service.messages) { msg in

                        let isMe =
                            msg.senderId ?? "" == auth.userId

                        VStack(
                            alignment: isMe
                            ? .trailing
                            : .leading,
                            spacing: 6
                        ) {

                            HStack(spacing: 6) {

                                Text(msg.sender)
                                    .font(.caption.bold())
                                    .foregroundColor(.orange)

                                if let date =
                                    msg.createdAt?.dateValue() {

                                    Text(
                                        date.formatted(
                                            date: .omitted,
                                            time: .shortened
                                        )
                                    )
                                    .font(.caption2)
                                    .foregroundColor(.white.opacity(0.75))
                                }
                            }

                            Text(msg.text)
                                .foregroundColor(.white)
                            if isWriteOffRequest(msg.text) {

                                Button {

                                    processWriteOff(msg.text)

                                } label: {

                                    HStack {

                                        Image(systemName: "shippingbox.fill")

                                        Text("Запрос на списание")
                                    }
                                    .font(.caption.bold())
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 8)
                                    .background(.orange)
                                    .foregroundColor(.white)
                                    .clipShape(
                                        RoundedRectangle(
                                            cornerRadius: 10
                                        )
                                    )
                                }
                                .padding(.top, 4)
                            }
                        }
                        .padding()
                        .background(
                            isMe
                            ? Color.orange.opacity(0.85)
                            : Color.white.opacity(0.08)
                        )
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 18
                            )
                        )
                        .frame(
                            maxWidth: .infinity,
                            alignment: isMe
                            ? .trailing
                            : .leading
                        )
                    }
                }
                .padding()
            }

            HStack {

                TextField(
                    "Сообщение...",
                    text: $text
                )
                .padding()
                .background(
                    Color.white.opacity(0.08)
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 16
                    )
                )

                Button {

                    service.send(
                        restaurantId: restaurantId,
                        sender: auth.employeeName,
                        senderId: auth.userId,
                        text: text
                    )

                    text = ""

                } label: {

                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.orange)
                        .clipShape(Circle())
                }
            }
            .padding()
        }
        .background(
            Color.black.ignoresSafeArea()
        )
        .navigationTitle("Чат")
        .onAppear {

            service.listen(
                restaurantId: restaurantId
            )
        }
    }
}
