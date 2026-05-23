import SwiftUI

struct SemiDetailView: View {
    
    let semi: SemiFinishedProduct
    
    var body: some View {
        
        ZStack {
            
            Image("FoodX")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            Color.black.opacity(0.85)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                
                VStack(
                    alignment: .leading,
                    spacing: 18
                ) {
                    
                    // TITLE
                    
                    Text(semi.name)
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                    
                    // OUTPUT
                    
                    Text(
                        "Выход: \(Int(semi.outputQuantityInGrams)) г"
                    )
                    .foregroundColor(.orange)
                    .font(.headline)
                    
                    Divider()
                        .background(Color.gray)
                    
                    // INGREDIENTS
                    
                    Text("Состав")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                    
                    VStack(spacing: 10) {
                        
                        ForEach(semi.ingredients) { ing in
                            
                            HStack {
                                
                                Text(ing.name)
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Text("\(Int(ing.grams)) г")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    
                    Divider()
                        .background(Color.gray)
                    
                    // TECHNOLOGY
                    
                    Text("Технология приготовления")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                    
                    Text(
                        semi.instruction.isEmpty
                        ? "Нет описания"
                        : semi.instruction
                    )
                    .foregroundColor(.gray)
                    .padding()
                    .background(
                        Color.white.opacity(0.05)
                    )
                    .clipShape(
                        RoundedRectangle(cornerRadius: 18)
                    )
                    
                    // PDF
                    
                    Button {
                        
                        guard let url =
                                TTKPDFExporter.export(semi: semi)
                        else {
                            return
                        }
                        
                        let vc = UIActivityViewController(
                            activityItems: [url],
                            applicationActivities: nil
                        )
                        
                        if let scene =
                            UIApplication.shared.connectedScenes.first
                            as? UIWindowScene,
                           let root =
                            scene.windows.first?.rootViewController {
                            
                            root.present(vc, animated: true)
                        }
                        
                    } label: {
                        
                        HStack {
                            
                            Image(systemName: "doc.richtext")
                            
                            Text("PDF / Поделиться")
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
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
    }
}
