import SwiftUI
import Combine

struct ChatView: View {
    
    let restaurantId: String
    
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
                        
                        VStack(
                            alignment: .leading,
                            spacing: 6
                        ) {
                            
                            Text(msg.sender)
                                .font(.caption.bold())
                                .foregroundColor(.orange)
                            
                            Text(msg.text)
                                .foregroundColor(.white)
                        }
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                        .padding()
                        .background(
                            Color.white.opacity(0.06)
                        )
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 18
                            )
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
        .onAppear {
            
            service.listen(
                restaurantId: restaurantId
            )
        }
    }
}
