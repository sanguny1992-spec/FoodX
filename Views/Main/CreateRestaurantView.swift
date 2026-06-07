import SwiftUI
import FirebaseAuth

struct CreateRestaurantView: View {

    @EnvironmentObject var auth: AuthManager

    @State private var restaurantName = ""

    private let restaurantService =
        RestaurantService()

    private let employeeService =
        EmployeeService()

    var body: some View {

        ZStack {

            Color.black
                .ignoresSafeArea()

            VStack(spacing: 20) {

                Text("Создать ресторан")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)

                TextField(
                    "Название ресторана",
                    text: $restaurantName
                )
                .padding()
                .background(Color.white)
                .clipShape(
                    RoundedRectangle(cornerRadius: 14)
                )

                Button {

                    createRestaurant()

                } label: {

                    Text("Создать")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 16)
                        )
                }
            }
            .padding()
        }
    }

    func createRestaurant() {

        restaurantService.createRestaurant(
            name: restaurantName
        ) { restaurantId in

            guard let restaurantId else {
                return
            }

            guard let user =
                auth.user
            else {
                return
            }

            employeeService.createEmployee(
                name: user.email ?? "Owner",
                email: user.email ?? "",
                restaurantId: restaurantId,
                role: "owner"
            )

            DispatchQueue.main.async {

                auth.restaurantId =
                    restaurantId

                auth.loadRestaurant(
                    restaurantId: restaurantId
                )
            }
        }
    }
}
