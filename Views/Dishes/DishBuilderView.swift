import SwiftUI
import PhotosUI

struct DishBuilderView: View {
    
    @ObservedObject var store: InventoryStore
    var editingDish: Dish?
    
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isFocused: Bool
    
    @State private var name = ""
    @State private var output = ""
    @State private var instruction = ""
    @State private var category = ""
    
    @EnvironmentObject var auth: AuthManager
    
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var imageData: Data?
    
    @State private var ingredients: [Ingredient] = []
    
    init(
        store: InventoryStore,
        editingDish: Dish? = nil
    ) {
        self.store = store
        self.editingDish = editingDish
        
        _name = State(
            initialValue: editingDish?.name ?? ""
        )
        
        _output = State(
            initialValue:
                editingDish != nil
                ? "\(Int(editingDish!.outputQuantityInGrams))"
                : ""
        )
        
        _instruction = State(
            initialValue: editingDish?.instruction ?? ""
        )
        
        _category = State(
            initialValue: editingDish?.category ?? ""
        )
        
        _imageData = State(
            initialValue: editingDish?.imageData
        )
        
        _ingredients = State(
            initialValue: editingDish?.ingredients ?? []
        )
    }
    
    var body: some View {
        
        ZStack {
            
            // BACKGROUND
            
            Image("FoodX")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            Color.black.opacity(0.9)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                // HEADER
                
                header
                
                // CONTENT
                
                ScrollView(showsIndicators: false) {
                    
                    VStack(spacing: 22) {
                        
                        // НАЗВАНИЕ
                        
                        blockTitle("Название блюда")
                        
                        glassField(
                            text: $name,
                            placeholder: "Например: Паста Карбонара"
                        )
                        
                        // КАТЕГОРИЯ
                        
                        blockTitle("Категория")
                        
                        glassField(
                            text: $category,
                            placeholder: "Например: Паста"
                        )
                        
                        // ВЫХОД
                        
                        blockTitle("Выход блюда")
                        
                        HStack {
                            
                            glassField(
                                text: $output,
                                placeholder: "0"
                            )
                            .keyboardType(.decimalPad)
                            
                            Text("г")
                                .foregroundColor(.orange)
                                .font(.headline)
                        }
                        
                        // ФОТО
                        
                        blockTitle("Фото блюда")
                        
                        PhotosPicker(
                            selection: $selectedPhoto,
                            matching: .images
                        ) {
                            
                            ZStack {
                                
                                RoundedRectangle(cornerRadius: 26)
                                    .fill(Color.white.opacity(0.06))
                                    .frame(height: 220)
                                
                                if let imageData,
                                   let uiImage = UIImage(data: imageData) {
                                    
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 220)
                                        .clipShape(
                                            RoundedRectangle(cornerRadius: 26)
                                        )
                                    
                                } else {
                                    
                                    VStack(spacing: 10) {
                                        
                                        Image(systemName: "photo")
                                            .font(.system(size: 42))
                                            .foregroundColor(.orange)
                                        
                                        Text("Добавить фото")
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                        }
                        .onChange(of: selectedPhoto) { newItem in
                            
                            Task {
                                
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    
                                    imageData = data
                                }
                            }
                        }
                        
                        // ИНГРЕДИЕНТЫ
                        
                        HStack {
                            
                            Text("Ингредиенты")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Button {
                                
                                ingredients.append(
                                    Ingredient(
                                        name: "",
                                        grams: 0
                                    )
                                )
                                
                            } label: {
                                
                                HStack(spacing: 6) {
                                    
                                    Image(systemName: "plus")
                                    
                                    Text("Добавить")
                                }
                                .foregroundColor(.orange)
                            }
                        }
                        
                        VStack(spacing: 12) {
                            
                            ForEach(ingredients.indices, id: \.self) { index in
                                
                                HStack(spacing: 12) {
                                    
                                    // НАЗВАНИЕ
                                    
                                    TextField(
                                        "Продукт",
                                        text: $ingredients[index].name
                                    )
                                    .focused($isFocused)
                                    .padding()
                                    .background(
                                        Color.white.opacity(0.06)
                                    )
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 18)
                                    )
                                    .foregroundColor(.white)
                                    
                                    // ГРАММЫ
                                    
                                    TextField(
                                        "г",
                                        value: $ingredients[index].grams,
                                        format: .number
                                    )
                                    .focused($isFocused)
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 90)
                                    .padding()
                                    .background(
                                        Color.white.opacity(0.06)
                                    )
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 18)
                                    )
                                    .foregroundColor(.orange)
                                    
                                    // УДАЛИТЬ
                                    
                                    Button {
                                        
                                        ingredients.remove(at: index)
                                        
                                    } label: {
                                        
                                        Image(systemName: "trash.fill")
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                        }
                        
                        // ОПИСАНИЕ
                        
                        blockTitle("Технология приготовления")
                        
                        TextEditor(text: $instruction)
                            .focused($isFocused)
                            .frame(height: 180)
                            .padding(12)
                            .scrollContentBackground(.hidden)
                            .background(
                                Color.white.opacity(0.06)
                            )
                            .clipShape(
                                RoundedRectangle(cornerRadius: 24)
                            )
                            .foregroundColor(.white)
                        
                        // СОХРАНИТЬ
                        
                        Button {
                            
                            isFocused = false
                            
                            guard let out = Double(
                                output.replacingOccurrences(
                                    of: ",",
                                    with: "."
                                )
                            ) else {
                                return
                            }
                            
                            let dish = Dish(
                                id: editingDish?.id ?? UUID(),
                                name: name,
                                category: category.isEmpty
                                ? "Без категории"
                                : category,
                                imageData: imageData,
                                outputQuantityInGrams: out,
                                ingredients: ingredients,
                                instruction: instruction
                            )
                            
                            if let index = store.dishes.firstIndex(
                                where: { $0.id == dish.id }
                            ) {
                                
                                store.dishes[index] = dish
                                
                            } else {
                                
                                store.dishes.append(dish)
                            }
                            
                            store.save()
                            MenuShareService().uploadMenu(
                                dishes: store.dishes,
                                restaurantId: auth.restaurantId
                            ) { result in

                                switch result {

                                case .success:
                                    print("✅ WEB обновлен")

                                case .failure(let error):
                                    print(error)
                                }
                            }
                            dismiss()
                            
                        } label: {
                            
                            Text("Сохранить блюдо")
                                .font(.headline.bold())
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
                                    RoundedRectangle(cornerRadius: 24)
                                )
                        }
                        .padding(.top, 8)
                        .padding(.bottom, 40)
                    }
                    .padding()
                }
                .scrollDismissesKeyboard(.interactively)
            }
        }
        .preferredColorScheme(.dark)
        .onTapGesture {
            isFocused = false
            hideKeyboard()
        }
    }
    
    // HEADER
    
    var header: some View {
        
        VStack(spacing: 0) {
            
            Color.clear
                .frame(height: 45)
            
            HStack {
                
                Button {
                    dismiss()
                } label: {
                    
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 46, height: 46)
                        .overlay {
                            
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                        }
                }
                
                Spacer()
                
                Text(
                    editingDish == nil
                    ? "Создать блюдо"
                    : "Редактор блюда"
                )
                .font(.title2.bold())
                .foregroundColor(.white)
                
                Spacer()
                
                Circle()
                    .fill(Color.orange)
                    .frame(width: 46, height: 46)
                    .overlay {
                        
                        Image(systemName: "fork.knife")
                            .foregroundColor(.black)
                    }
            }
            .padding(.horizontal)
            .padding(.bottom, 12)
        }
        .background(Color.black.opacity(0.96))
    }
    
    // TITLE
    
    func blockTitle(_ text: String) -> some View {
        
        HStack {
            
            Text(text)
                .font(.headline)
                .foregroundColor(.white)
            
            Spacer()
        }
    }
    
    // FIELD
    
    func glassField(
        text: Binding<String>,
        placeholder: String
    ) -> some View {
        
        TextField(
            "",
            text: text,
            prompt: Text(placeholder)
                .foregroundColor(.white.opacity(0.35))
        )
        .focused($isFocused)
        .foregroundColor(.white)
        .padding()
        .background(
            Color.white.opacity(0.06)
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 20)
        )
    }
}

// HIDE KEYBOARD

extension View {
    
    func hideKeyboard() {
        
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}
