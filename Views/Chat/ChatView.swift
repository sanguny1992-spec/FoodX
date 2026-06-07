import SwiftUI
import FirebaseFirestore

struct ChatView: View {

    let restaurantId: String

    @EnvironmentObject var auth: AuthManager
    @EnvironmentObject var store: InventoryStore

    @StateObject private var service = ChatService()

    @State private var text = ""
    @State private var showWriteOffAlert = false
    @State private var pendingWriteOffText = ""

    // MARK: - CHECK

    func isWriteOffRequest(_ text: String) -> Bool {
        let lower = text.lowercased()
        return lower.contains("списать") ||
               lower.contains("спишите") ||
               lower.contains("списание")
    }

    // MARK: - WRITE OFF PARSER

    func processWriteOff(_ text: String) {

        let lower = text.lowercased()

        // 1. regex: число + единица (кг/г)
        let pattern = #"(\d+(?:[.,]\d+)?)\s*(кг|г)?"#

        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: lower,
                                           range: NSRange(lower.startIndex..., in: lower)),
              let range = Range(match.range(at: 1), in: lower)
        else {
            print("❌ не найдено количество")
            return
        }

        var amountString = String(lower[range])
            .replacingOccurrences(of: ",", with: ".")

        guard var amount = Double(amountString) else {
            print("❌ ошибка числа")
            return
        }

        // 2. определяем единицы измерения
        let unitRange = Range(match.range(at: 2), in: lower)
        let unit = unitRange != nil ? String(lower[unitRange!]) : "г"

        if unit.contains("кг") {
            amount *= 1000
        }

        // 3. чистим текст от лишнего
        var search = lower

        let stopWords = [
            "списать",
            "спишите",
            "списание",
            "персонал",
            "на персонал",
            "порча",
            "дегустация"
        ]

        for word in stopWords {
            search = search.replacingOccurrences(of: word, with: "")
        }

        // убрать число + единицу
        search = search.replacingOccurrences(of: amountString, with: "")
        search = search.replacingOccurrences(of: unit, with: "")

        search = search
            .replacingOccurrences(of: "  ", with: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        // 4. поиск продукта
        guard let index = store.products.firstIndex(where: {
            $0.name.lowercased().contains(search) ||
            search.contains($0.name.lowercased())
        }) else {
            print("❌ Продукт не найден: \(search)")
            return
        }

        let product = store.products[index]

        // 5. списание
        store.products[index].quantityInGrams -= amount
        if store.products[index].quantityInGrams < 0 {
            store.products[index].quantityInGrams = 0
        }

        // 6. запись
        let record = WriteOffRecord(
            productName: product.name,
            grams: amount,
            reason: "Чат списание",
            employee: auth.employeeName
        )

        store.writeOffs.append(record)
        store.save()

        print("✅ Списано \(amount) г из \(product.name)")
    }

    // MARK: - VIEW

    var body: some View {

        VStack {

            ScrollView {

                LazyVStack(spacing: 14) {

                    ForEach(service.messages) { msg in

                        let isMe = msg.senderId ?? "" == auth.userId
                        let isWriteOff = isWriteOffRequest(msg.text)

                        VStack(alignment: isMe ? .trailing : .leading, spacing: 6) {

                            HStack(spacing: 6) {
                                Text(msg.sender)
                                    .font(.caption.bold())
                                    .foregroundColor(.orange)

                                if let date = msg.createdAt?.dateValue() {
                                    Text(date.formatted(date: .omitted, time: .shortened))
                                        .font(.caption2)
                                        .foregroundColor(.white.opacity(0.75))
                                }
                            }

                            Text(msg.text)
                                .foregroundColor(.white)

                            if isWriteOff {

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
                                    .background(Color.orange)
                                    .foregroundColor(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                                .padding(.top, 4)
                            }
                        }
                        .padding()
                        .background(isMe ? Color.orange.opacity(0.85) : Color.white.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .frame(maxWidth: .infinity, alignment: isMe ? .trailing : .leading)
                    }
                }
                .padding()
            }

            // INPUT

            HStack {

                TextField("Сообщение...", text: $text)
                    .padding()
                    .background(Color.white.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 16))

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
        .background(Color.black.ignoresSafeArea())
        .navigationTitle("Чат")

        .alert("Подтвердить списание", isPresented: $showWriteOffAlert) {

            Button("Отмена", role: .cancel) {}

            Button("Списать") {
                processWriteOff(pendingWriteOffText)
            }

        } message: {
            Text(pendingWriteOffText)
        }

        .onAppear {
            service.listen(restaurantId: restaurantId)
        }
    }
}
