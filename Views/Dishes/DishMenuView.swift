import SwiftUI
import UIKit

struct DishMenuView: View {
    
    @State private var showLinkAlert = false
    @State private var currentLink = ""
    @State private var shareLink = ""
    @State private var showShare = false
    
    @ObservedObject var store: InventoryStore
    
    @State private var selectedCategory = "Все"
    
    
    
    
    var categories: [String] {
        
        let all = store.dishes.map { $0.category }
        
        return ["Все"] + Array(Set(all)).sorted()
    }
    
    var filteredDishes: [Dish] {
        
        if selectedCategory == "Все" {
            return store.dishes
        }
        
        return store.dishes.filter {
            $0.category == selectedCategory
        }
    }
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                // BACKGROUND
                
                Image("FoodX")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                Color.black.opacity(0.82)
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    
                    VStack(spacing: 16) {
                        
                        // HEADER
                        
                        HStack {
                            
                            Text("Меню")
                                .font(.largeTitle.bold())
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            // SHARE
                            
                            Button {
                                
                                shareMenu()
                                
                            } label: {
                                
                                Image(systemName: "square.and.arrow.up")
                                    .font(.title2)
                                    .foregroundColor(.orange)
                            }
                        }
                        .padding(.bottom, 10)
                        
                        // КАТЕГОРИИ
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            
                            HStack(spacing: 10) {
                                
                                ForEach(categories, id: \.self) { category in
                                    
                                    Button {
                                        
                                        selectedCategory = category
                                        
                                    } label: {
                                        
                                        Text(category)
                                            .foregroundColor(
                                                selectedCategory == category
                                                ? .black
                                                : .white
                                            )
                                            .padding(.horizontal, 18)
                                            .padding(.vertical, 10)
                                            .background(
                                                selectedCategory == category
                                                ? Color.orange
                                                : Color.white.opacity(0.08)
                                            )
                                            .clipShape(Capsule())
                                    }
                                }
                            }
                        }
                        
                        // СОЗДАТЬ БЛЮДО
                        
                        NavigationLink {
                            
                            DishBuilderView(
                                store: store,
                                editingDish: nil
                            )
                            
                        } label: {
                            
                            HStack {
                                
                                Image(systemName: "plus.circle.fill")
                                
                                Text("Создать блюдо")
                                    .fontWeight(.bold)
                            }
                            .font(.title3)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [.orange, .red],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(
                                RoundedRectangle(cornerRadius: 22)
                            )
                        }
                        
                        // СПИСОК БЛЮД
                        
                        ForEach(filteredDishes) { dish in
                            
                            NavigationLink {
                                
                                DishBuilderView(
                                    store: store,
                                    editingDish: dish
                                )
                                
                            } label: {
                                
                                HStack(spacing: 16) {
                                    
                                    // IMAGE
                                    
                                    ZStack {
                                        
                                        RoundedRectangle(
                                            cornerRadius: 18
                                        )
                                        .fill(
                                            Color.orange.opacity(0.15)
                                        )
                                        .frame(
                                            width: 70,
                                            height: 70
                                        )
                                        
                                        if let imageData = dish.imageData,
                                           let uiImage = UIImage(data: imageData) {
                                            
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 70, height: 70)
                                                .clipShape(
                                                    RoundedRectangle(cornerRadius: 18)
                                                )
                                            
                                        } else {
                                            
                                            Image(systemName: "fork.knife")
                                                .font(.title2)
                                                .foregroundColor(.orange)
                                        }
                                    }
                                    
                                    // INFO
                                    
                                    VStack(
                                        alignment: .leading,
                                        spacing: 6
                                    ) {
                                        
                                        Text(dish.name)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        
                                        Text(
                                            "\(Int(dish.outputQuantityInGrams)) г"
                                        )
                                        .foregroundColor(.orange)
                                        
                                        Text(
                                            "\(dish.ingredients.count) ингредиентов"
                                        )
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(
                                    Color.white.opacity(0.05)
                                )
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 24)
                                )
                            }
                        }
                    }
                    .padding()
                    .padding(.top, 60)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .preferredColorScheme(.dark)
        .alert("Ссылка скопирована", isPresented: $showLinkAlert) {
            
            Button("OK") { }
            
        } message: {
            
            Text(currentLink)
        }
        .sheet(isPresented: $showShare) {
            
            FoodShareSheet(
                url: shareLink
            )
        }
    }
    
    // MARK: - SHARE
    
    func shareMenu() {
        
        let service = MenuShareService()
        
        service.uploadMenu(
            
            dishes: store.dishes,
            restaurantId: "demo_restaurant"
            
        ) { result in
            
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success(let link):
                    
                    currentLink = link
                    
                    UIPasteboard.general.string = link
                    
                    showLinkAlert = true
                    
                case .failure(let error):
                    
                    print(error.localizedDescription)
                }
            }
        }
    }
}
