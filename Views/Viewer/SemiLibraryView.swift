import SwiftUI

struct SemiLibraryView: View {
    
    @State private var semiShareLink = ""
    @State private var showShare = false

    private let semiService = SemiShareService()
    
    
    @ObservedObject var store: InventoryStore
    
    @State private var search = ""
    
    var filtered: [SemiFinishedProduct] {
        
        if search.isEmpty {
            return store.semiProducts
        }
        
        return store.semiProducts.filter {
            $0.name.lowercased()
                .contains(search.lowercased())
        }
    }
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                Image("FoodX")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                Color.black.opacity(0.85)
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    
                    VStack(spacing: 16) {
                        Button {
                            
                            shareSemiProducts()
                            
                        } label: {
                            
                            HStack {
                                
                                Image(systemName: "square.and.arrow.up")
                                
                                Text("Поделиться полуфабрикатами")
                                    .fontWeight(.bold)
                            }
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 18)
                            )
                        }
                        
                        Text("База полуфабрикатов")
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                            .padding(.top, 20)
                        
                        TextField(
                            "Поиск полуфабриката",
                            text: $search
                        )
                        .padding()
                        .background(
                            Color.white.opacity(0.08)
                        )
                        .clipShape(
                            RoundedRectangle(cornerRadius: 18)
                        )
                        .foregroundColor(.white)
                        
                        VStack(spacing: 14) {
                            
                            ForEach(filtered) { semi in
                                
                                NavigationLink {
                                    
                                    SemiDetailView(semi: semi)
                                    
                                } label: {
                                    
                                    VStack(
                                        alignment: .leading,
                                        spacing: 10
                                    ) {
                                        
                                        Text(semi.name)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        
                                        Text(
                                            "Выход: \(Int(semi.outputQuantityInGrams)) г"
                                        )
                                        .foregroundColor(.orange)
                                        
                                        Text(
                                            "\(semi.ingredients.count) ингредиентов"
                                        )
                                        .foregroundColor(.gray)
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
                                        RoundedRectangle(
                                            cornerRadius: 22
                                        )
                                    )
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showShare) {
            
            ShareSheet(
                items: [semiShareLink]
            )
        }
    }
    
    func shareSemiProducts() {
        
        semiService.uploadSemiProducts(
            semiProducts: store.semiProducts,
            restaurantId: "demo_restaurant"
        ) { result in
            
            switch result {
                
            case .success(let link):
                
                DispatchQueue.main.async {
                    
                    semiShareLink = link
                    showShare = true
                }
                
            case .failure(let error):
                
                print(error.localizedDescription)
            }
        }
    }
    
}
