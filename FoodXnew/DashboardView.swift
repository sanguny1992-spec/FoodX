import SwiftUI

struct DashboardView: View {

    @Binding var showMenu: Bool
    @Binding var showSchedule: Bool
    @State private var showSemi = false
    @State private var showWriteOffs = false
    @EnvironmentObject var auth: AuthManager
    @ObservedObject var store: InventoryStore

    var body: some View {

        VStack(spacing: 18) {

            announcementCard

            LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ],
                spacing: 16
            ) {

                NavigationLink {

                    StockView(store: store)

                } label: {

                    tile(
                        title: "Склад",
                        icon: "cube.box.fill"
                    )
                }

                NavigationLink {

                    SemiProductsView(store: store)

                } label: {

                    tile(
                        title: "Полуфабрикаты",
                        icon: "carrot.fill"
                    )
                }
                }

                Button {

                    showMenu = true

                } label: {

                    tile(
                        title: "Меню",
                        icon: "menucard.fill"
                    )
                }

                Button {

                    showSchedule = true

                } label: {

                    tile(
                        title: "График",
                        icon: "calendar"
                    )
                }

                NavigationLink {

                    ChatView(
                        restaurantId: auth.restaurantId
                    )
                    .environmentObject(store)

                } label: {

                    tile(
                        title: "Чат",
                        icon: "message.fill"
                    )
                }

            NavigationLink {

                WriteOffsView(store: store)

            } label: {

                tile(
                    title: "Списания",
                    icon: "doc.text.fill"
                )
            }
            }
        }
    }

    var announcementCard: some View {

        VStack(alignment: .leading, spacing: 8) {

            Text("📢 Анонсы")
                .font(.headline)

            Text("Инвентаризация завтра в 09:00")

            Text("Проверить остатки лосося")

            Text("Генеральная уборка понедельник")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(
            RoundedRectangle(cornerRadius: 20)
        )
    }

    func tile(
        title: String,
        icon: String
    ) -> some View {

        VStack(spacing: 12) {

            Image(systemName: icon)
                .font(.largeTitle)

            Text(title)
                .font(.headline)
        }
        .foregroundColor(.orange)
        .frame(maxWidth: .infinity)
        .frame(height: 130)
        .background(.ultraThinMaterial)
        .clipShape(
            RoundedRectangle(cornerRadius: 24)
        )
    }

