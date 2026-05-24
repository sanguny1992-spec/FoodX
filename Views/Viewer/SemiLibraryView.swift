import SwiftUI

struct SemiLibraryView: View {
    
    @ObservedObject var store: InventoryStore
    
    @State private var search = ""
    
    @State private var semiShareLink = ""
    @State private var showShare = false
    
    private let semiService = SemiShareService()
    
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
                        
                        // SHARE BUTTON
                        
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
                        
                        // TITLE
                        
                        Text("База полуфабрикатов")
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                            .padding(.top, 10)
                        
                        // SEARCH
                        
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
                        
                        // LIST
                        
                        VStack(spacing: 14) {
                            
                            ForEach(filtered) { semi in
                                
                                SemiRow(
                                    store: store,
                                    semi: semi
                                )
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
    
    // MARK: SHARE
    
    func shareSemiProducts() {
        
        semiService.uploadSemiProducts(
            semiProducts: store.semiProducts,
            restaurantId: "6A0C27E2-2B87-4EB3-9576-6AC17129727D"
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
