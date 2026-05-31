import SwiftUI

struct ProductCard: View {

    let product: Product

    var body: some View {

        VStack(
            alignment: .leading,
            spacing: 10
        ) {

            Text(product.name)
                .font(.headline)

            Text(
                "\(Int(product.quantityInGrams)) г"
            )
            .foregroundColor(.orange)

            if let price = product.pricePerKg {

                Text(
                    "\(price.formatted()) €/кг"
                )
                .foregroundColor(.gray)
            }
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
                cornerRadius: 20
            )
        )
    }
}
