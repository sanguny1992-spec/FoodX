import SwiftUI
import Combine

struct KeyboardAdaptive: ViewModifier {
    
    @State private var keyboardHeight: CGFloat = 0
    
    func body(content: Content) -> some View {
        
        content
            .padding(.bottom, keyboardHeight)
            .animation(
                .easeOut(duration: 0.25),
                value: keyboardHeight
            )
            .onReceive(
                NotificationCenter.default.publisher(
                    for: UIResponder.keyboardWillShowNotification
                )
            ) { notification in
                
                guard let frame = notification.userInfo?[
                    UIResponder.keyboardFrameEndUserInfoKey
                ] as? CGRect else {
                    return
                }
                
                keyboardHeight = frame.height * 0.7
            }
            .onReceive(
                NotificationCenter.default.publisher(
                    for: UIResponder.keyboardWillHideNotification
                )
            ) { _ in
                
                keyboardHeight = 0
            }
    }
}

extension View {
    
    func keyboardAdaptive() -> some View {
        
        modifier(KeyboardAdaptive())
    }
}
