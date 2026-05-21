import SwiftUI

struct SupplierDetailView: View {
    
    let supplier: Supplier
    
    var body: some View {
        
        ZStack {
            
            Image("FoodX")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            Color.black.opacity(0.85)
                .ignoresSafeArea()
            
            ScrollView {
                
                VStack(
                    alignment: .leading,
                    spacing: 20
                ) {
                    
                    // TITLE
                    
                    Text(supplier.name)
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                    
                    // CATEGORY
                    
                    infoCard(
                        title: "Категория",
                        value: supplier.category
                    )
                    
                    // MANAGER
                    
                    infoCard(
                        title: "Менеджер",
                        value: supplier.managerName
                    )
                    
                    // PHONE
                    
                    infoCard(
                        title: "Телефон",
                        value: supplier.phone
                    )
                    
                    // COMMENT
                    
                    infoCard(
                        title: "Комментарий",
                        value: supplier.comment
                    )
                }
                .padding()
                .padding(.top, 30)
            }
        }
        .preferredColorScheme(.dark)
    }
    
    // MARK: CARD
    
    func infoCard(
        title: String,
        value: String
    ) -> some View {
        
        VStack(
            alignment: .leading,
            spacing: 8
        ) {
            
            Text(title)
                .foregroundColor(.gray)
            
            Text(
                value.isEmpty
                ? "Не указано"
                : value
            )
            .foregroundColor(.white)
            .font(.headline)
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding()
        .background(
            Color.white.opacity(0.05)
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 22)
        )
    }
}
