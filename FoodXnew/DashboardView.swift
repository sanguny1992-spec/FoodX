import SwiftUI

struct DashboardView: View {

    @Binding var showMenu: Bool
    @Binding var showSchedule: Bool
    @State private var showSemi = false
    @State private var showWriteOffs = false

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

                Button {

                    showSemi = true

                } label: {

                    tile(
                        title: "Полуфабрикаты",
                        icon: "carrot.fill"
                    )
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
                        restaurantId: "6A0C27E2-2B87-4EB3-9576-6AC17129727D"
                    )
                    .environmentObject(store)

                } label: {

                    tile(
                        title: "Чат",
                        icon: "message.fill"
                    )
                }

                Button {

                    showWriteOffs = true

                } label: {

                    tile(
                        title: "Списания",
                        icon: "doc.text.fill"
                    )
                }
            }
        }
        .sheet(isPresented: $showSemi) {

            SemiProductsView(
                store: store
            )
        }

        .sheet(isPresented: $showWriteOffs) {

            Text("Журнал списаний")
                .font(.title)
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
    
    
}
