import SwiftUI

struct TTKEditorView: View {

    @Binding var text: String
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            TextEditor(text: $text)
            Button("Готово") {
                dismiss()
            }
        }
        .padding()
    }
}




