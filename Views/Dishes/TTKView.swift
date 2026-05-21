import SwiftUI

struct TTKView: View {

    @Binding var name: String
    @Binding var grams: String
    @Binding var text: String
    

    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {

            ZStack {
                Color.black.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 6) {

                            Text(name.isEmpty ? "Без названия" : name)
                                .font(.headline)
                                .foregroundColor(.white)

                            Text("\(grams) г")
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.white.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        // 📦 ПРОДУКТ
                        TextField("Продукт", text: $name)
                            .padding()
                            .background(Color.white.opacity(0.06))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))

                        // ⚖️ ГРАММЫ
                        TextField("Граммы", text: $grams)
                            .padding()
                            .background(Color.white.opacity(0.06))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))

                        // 🧠 ТЕХНОЛОГИЯ
                        TextEditor(text: $text)
                            .frame(minHeight: 200)
                            .padding()
                            .background(Color.white.opacity(0.06))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding()
                }
            }
            .navigationTitle("ТТК")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        dismiss()
                    }
                    .foregroundColor(.orange)
                }
            }
        }
    }
}
