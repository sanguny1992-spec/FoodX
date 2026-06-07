import SwiftUI
import FirebaseFirestore

struct ChatMessageRow: View {

    let msg: ChatMessage
    let isMe: Bool
    let isWriteOff: Bool
    let onWriteOff: () -> Void

    var body: some View {

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

                Button(action: onWriteOff) {

                    HStack {
                        Image(systemName: "shippingbox.fill")
                        Text("Запрос на списание")
                    }
                    .font(.caption.bold())
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(.orange)
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
