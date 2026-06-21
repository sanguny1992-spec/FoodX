import SwiftUI
import FirebaseFirestore

struct ChatView: View {
    
    let restaurantId: String
    
    @EnvironmentObject var auth: AuthManager
    @EnvironmentObject var store: InventoryStore
    
    @StateObject private var service = ChatService()
    
    @State private var text = ""
    
    // MARK: candidates
    @State private var showCandidatesSheet = false
    @State private var candidates: [String] = []
    @State private var selectedMessage = ""
    
    @State private var parsedItems: [ChatWriteOffItem] = []
    
    @State private var selectedProductName = ""
    
    @State private var showWriteOffEditor = false
    @State private var draftItems: [WriteOffDraftItem] = []
    
    
    // MARK: write off check
    func isWriteOffRequest(_ text: String) -> Bool {
        let lower = text.lowercased()
        return lower.contains("списать") ||
        lower.contains("спишите") ||
        lower.contains("списание")
    }
    func parseWriteOffMessage(_ text: String) -> [WriteOffDraftItem] {
        
        var result: [WriteOffDraftItem] = []
        
        let lines = text.components(separatedBy: .newlines)
        
        for line in lines {
            
            let words = line.split(separator: " ")
            
            guard words.count >= 2 else {
                continue
            }
            
            guard let grams = Double(words.last!) else {
                continue
            }
            
            let productName = words.dropLast().joined(separator: " ")
            
            result.append(
                WriteOffDraftItem(
                    productName: productName,
                    grams: grams
                )
            )
        }
        
        return result
    }
    // MARK: search
    func findCandidates(from text: String) -> [String] {
        
        let words = text.lowercased()
            .components(separatedBy: .whitespacesAndNewlines)
            .filter { $0.count > 2 }
        
        let allItems =
        store.products.map { $0.name } +
        store.semiProducts.map { $0.name }
        
        var result: [String] = []
        
        for item in allItems {
            
            let itemLower = item.lowercased()
            
            for word in words {
                
                let root = String(word.prefix(4))
                
                if itemLower.contains(root) {
                    result.append(item)
                    break
                }
            }
        }
        
        return Array(Set(result)).sorted()
    }
    
    func applyWriteOff(
        message: String,
        selectedName: String
    ) {
        
        let lower = message.lowercased()
        
        let pattern = #"(\d+(?:[.,]\d+)?)"#
        
        guard
            let regex = try? NSRegularExpression(pattern: pattern),
            let match = regex.firstMatch(
                in: lower,
                range: NSRange(lower.startIndex..., in: lower)
            ),
            let range = Range(match.range, in: lower)
        else {
            return
        }
        
        let amountString = String(lower[range])
            .replacingOccurrences(of: ",", with: ".")
        
        guard let amount = Double(amountString) else {
            return
        }
        
        if let index = store.products.firstIndex(where: {
            $0.name.lowercased() == selectedName.lowercased()
        }) {
            
            store.products[index].quantityInGrams -= amount
            
            if store.products[index].quantityInGrams < 0 {
                store.products[index].quantityInGrams = 0
            }
            
            store.save()
        }
    }
    func performDraftWriteOff() {
        
        for item in draftItems where item.isSelected {
            
            guard let index = store.products.firstIndex(where: {
                $0.name == item.productName
            }) else { continue }
            
            store.products[index].quantityInGrams -= item.grams
            
            if store.products[index].quantityInGrams < 0 {
                store.products[index].quantityInGrams = 0
            }
            
            store.writeOffs.append(
                WriteOffRecord(
                    productName: item.productName,
                    grams: item.grams,
                    reason: "Чат",
                    employee: auth.employeeName
                )
            )
        }
        
        store.save()
    }
    
    // MARK: BODY
    var body: some View {
        
        VStack(spacing: 0) {
            
            ScrollViewReader { proxy in
                
                ScrollView {
                    
                    LazyVStack(spacing: 14) {
                        
                        ForEach(service.messages) { msg in
                            
                            let isMe = msg.senderId ?? "" == auth.userId
                            let isWriteOff = isWriteOffRequest(msg.text)
                            
                            VStack(alignment: isMe ? .trailing : .leading, spacing: 6) {
                                
                                HStack {
                                    Text(msg.sender)
                                        .font(.caption.bold())
                                        .foregroundColor(.orange)
                                    
                                    if let date = msg.createdAt?.dateValue() {
                                        Text(date.formatted(date: .omitted, time: .shortened))
                                            .font(.caption2)
                                            .foregroundColor(.white.opacity(0.7))
                                        Color.clear
                                            .frame(height: 1)
                                            .id("BOTTOM")
                                    }
                                }
                                
                                Text(msg.text)
                                    .foregroundColor(.white)
                                
                                if isWriteOff {
                                    Button {
                                        selectedMessage = msg.text
                                        candidates = findCandidates(from: msg.text)
                                        showCandidatesSheet = true
                                    } label: {
                                        HStack {
                                            Image(systemName: "shippingbox.fill")
                                            Text("Списать")
                                        }
                                        .font(.caption.bold())
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 8)
                                        .background(Color.orange)
                                        .foregroundColor(.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                }
                            }
                            .padding()
                            .background(isMe ? Color.orange.opacity(0.85) : Color.white.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .frame(maxWidth: .infinity, alignment: isMe ? .trailing : .leading)
                        }
                        Color.clear
                            .frame(height: 1)
                            .id("BOTTOM")
                    }
                    .padding(.bottom, 80)
                    
                    .onChange(of: service.messages.count) { _ in
                        
                        DispatchQueue.main.async {
                            
                            withAnimation {
                                
                                proxy.scrollTo(
                                    "BOTTOM",
                                    anchor: .bottom
                                )
                            }
                        }
                    }
                    
                    .onAppear {
                        
                        DispatchQueue.main.asyncAfter(
                            deadline: .now() + 0.3
                        ) {
                            
                            proxy.scrollTo(
                                "BOTTOM",
                                anchor: .bottom
                            )
                        }
                    }
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
                .background(Color.black)
            }
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("Чат")
            
            // SHEET
            .sheet(isPresented: $showCandidatesSheet) {
                
                VStack(spacing: 16) {
                    
                    Text("Выберите продукт")
                        .font(.headline)
                    
                    if candidates.isEmpty {
                        
                        Text("Ничего не найдено")
                            .foregroundColor(.gray)
                        
                        Button("Закрыть") {
                            showCandidatesSheet = false
                        }
                        
                    } else {
                        
                        ScrollView {
                            
                            VStack(spacing: 12) {
                                
                                ForEach(candidates, id: \.self) { item in
                                    
                                    Button {
                                        
                                        selectedProductName = item
                                        
                                    } label: {
                                        
                                        HStack {
                                            Text(item)
                                            Spacer()
                                        }
                                        .padding()
                                        .background(Color.white.opacity(0.1))
                                        .cornerRadius(12)
                                    }
                                }
                                if !selectedProductName.isEmpty {
                                    
                                    Text("Выбрано:")
                                        .foregroundColor(.gray)
                                    
                                    Text(selectedProductName)
                                        .font(.headline)
                                    
                                    Button {
                                        
                                        draftItems = [
                                            WriteOffDraftItem(
                                                productName: selectedProductName,
                                                grams: 0
                                            )
                                        ]
                                        
                                        showWriteOffEditor = true
                                        
                                    }
                                    
                                    label: {
                                        
                                        Text("Подтвердить списание")
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(Color.orange)
                                            .foregroundColor(.white)
                                            .cornerRadius(12)
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                }
                .padding()
            }
            
            .onAppear {
                service.listen(restaurantId: restaurantId)
            }
        }
    }
    
    
}
