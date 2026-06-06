import SwiftUI

struct PendingView: View {

    var body: some View {

        ZStack {

            Color.black
                .ignoresSafeArea()

            VStack(spacing: 24) {

                Image(systemName: "clock.badge.questionmark")
                    .font(.system(size: 80))
                    .foregroundColor(.orange)

                Text("Заявка отправлена")
                    .font(.title.bold())
                    .foregroundColor(.white)

                Text("Ожидайте подтверждения администратора")
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
    }
}
