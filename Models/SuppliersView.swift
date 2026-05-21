import SwiftUI

struct SuppliersView: View {
    
    @StateObject private var supplierStore = SupplierStore()
    
    @State private var name = ""
    @State private var category = ""
    @State private var manager = ""
    @State private var phone = ""
    
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
                        
                        // TITLE
                        
                        Text("Поставщики")
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                            .padding(.top, 30)
                        
                        // NAME
                        
                        customField(
                            "Название",
                            text: $name
                        )
                        
                        // CATEGORY
                        
                        customField(
                            "Категория",
                            text: $category
                        )
                        
                        // MANAGER
                        
                        customField(
                            "Менеджер",
                            text: $manager
                        )
                        
                        // PHONE
                        
                        customField(
                            "Телефон",
                            text: $phone
                        )
                        
                        // SAVE
                        
                        Button {
                            
                            addSupplier()
                            
                        } label: {
                            
                            Text("Добавить поставщика")
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.orange)
                                .clipShape(
                                    RoundedRectangle(
                                        cornerRadius: 18
                                    )
                                )
                        }
                        
                        // LIST
                        
                        VStack(spacing: 14) {
                            
                            ForEach(
                                supplierStore.suppliers
                            ) { supplier in
                                
                                NavigationLink {
                                    
                                    SupplierDetailView(
                                        supplier: supplier
                                    )
                                    
                                } label: {
                                    
                                    VStack(
                                        alignment: .leading,
                                        spacing: 8
                                    ) {
                                        
                                        Text(supplier.name)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        
                                        if !supplier.category.isEmpty {
                                            
                                            Text(
                                                supplier.category
                                            )
                                            .foregroundColor(.orange)
                                        }
                                        
                                        if !supplier.managerName.isEmpty {
                                            
                                            Text(
                                                "Менеджер: \(supplier.managerName)"
                                            )
                                            .foregroundColor(.gray)
                                        }
                                        
                                        if !supplier.phone.isEmpty {
                                            
                                            Text(supplier.phone)
                                                .foregroundColor(.gray)
                                        }
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
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    // MARK: FIELD
    
    func customField(
        _ placeholder: String,
        text: Binding<String>
    ) -> some View {
        
        TextField(
            placeholder,
            text: text
        )
        .padding()
        .background(
            Color.white.opacity(0.08)
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 18)
        )
        .foregroundColor(.white)
    }
    
    // MARK: ADD
    
    func addSupplier() {
        
        guard !name.isEmpty else {
            return
        }
        
        let supplier = Supplier(
            name: name,
            category: category,
            managerName: manager,
            phone: phone
        )
        
        supplierStore.suppliers.append(
            supplier
        )
        
        supplierStore.save()
        
        name = ""
        category = ""
        manager = ""
        phone = ""
    }
}
