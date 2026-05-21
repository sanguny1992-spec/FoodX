import SwiftUI
import UIKit

struct FoodShareSheet: UIViewControllerRepresentable {

    let url: String

    func makeUIViewController(
        context: Context
    ) -> UIActivityViewController {

        let controller = UIActivityViewController(
            activityItems: [NSURL(string: url)!],
            applicationActivities: nil
        )

        return controller
    }

    func updateUIViewController(
        _ uiViewController: UIActivityViewController,
        context: Context
    ) {

    }
}
