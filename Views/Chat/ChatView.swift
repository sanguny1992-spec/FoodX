import SwiftUI
import FirebaseFirestore

struct ChatView: View {

    let restaurantId: String

    @EnvironmentObject var auth: AuthManager

    @StateObject private var service =
        ChatService()

    @State private var text = ""

    var body: some View {

        VStack {

            ScrollView {

                LazyVStack(
                    spacing: 14
                ) {

                    ForEach(service.messages) { msg in

                        let isMe =
                            msg.senderId == auth.userId

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
