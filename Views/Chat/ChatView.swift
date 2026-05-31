import SwiftUI
import FirebaseFirestore

struct ChatView: View {

    let restaurantId: String

    @EnvironmentObject var auth: AuthManager

    @StateObject private var service =
        ChatService()

    @State private var text = ""
    @State private var showWriteOffAlert = false
    @State private var pendingWriteOffText = ""
    @State private var writeOffMessage = ""
    
    
    
    
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

        var searchProductName = lower

        searchProductName = searchProductName
            .replacingOccurrences(of: "списать", with: "")
            .replacingOccurrences(of: "спишите", with: "")
            .replacingOccurrences(of: "списание", with: "")
            .replacingOccurrences(of: amountWord, with: "")
            .replacingOccurrences(of: "на персонал", with: "")
            .replacingOccurrences(of: "персонал", with: "")
            .replacingOccurrences(of: "порча", with: "")
            .replacingOccurrences(of: "дегустация", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard let index = store.products.firstIndex(where: {

            $0.name.lowercased().contains(searchProductName)

        }) else {

            print("Продукт не найден: \(searchProductName)")
            return
        }

        let realProductName = store.products[index].name

        store.products[index].quantityInGrams -= amount

        if store.products[index].quantityInGrams < 0 {
            store.products[index].quantityInGrams = 0
        }

        let reason: String

        if lower.contains("персонал") {

            reason = "Персонал"

        } else if lower.contains("порча") {

            reason = "Порча"

        } else if lower.contains("дегустация") {

            reason = "Дегустация"

        } else {

            reason = "Другое"
        }

        let record = WriteOffRecord(
            productName: realProductName,
            grams: amount,
            reason: reason,
            employee: auth.employeeName
        )

        store.writeOffs.append(record)

        store.save()

        print("Списано \(amount) г из \(realProductName)")
    
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

                                    pendingWriteOffText = msg.text
                                    showWriteOffAlert = true

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
        .alert(
            "Подтвердить списание",
            isPresented: $showWriteOffAlert
        ) {

            Button("Отмена", role: .cancel) { }

            Button("Списать") {

                processWriteOff(pendingWriteOffText)
            }

        } message: {

            Text(pendingWriteOffText)
        }
        .onAppear {

            service.listen(
                restaurantId: restaurantId
            )
        }
    }
}
