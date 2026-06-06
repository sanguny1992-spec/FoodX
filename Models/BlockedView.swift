import SwiftUI

struct BlockedView: View {

    var body: some View {

        ZStack {

            Color.black
                .ignoresSafeArea()

            VStack(spacing: 24) {

                Image(systemName: "lock.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.red)

                Text("Доступ заблокирован")
                    .font(.title.bold())
                    .foregroundColor(.white)

                Text("Обратитесь к администратору")
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
    }
}
