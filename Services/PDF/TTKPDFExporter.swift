import UIKit

struct TTKPDFExporter {
    
    // MARK: - ТТК (полуфабрикат)
    static func export(semi: SemiFinishedProduct) -> URL? {
        
        let renderer = UIGraphicsPDFRenderer(
            bounds: CGRect(x: 0, y: 0, width: 595, height: 842)
        )
        
        let data = renderer.pdfData { ctx in
            ctx.beginPage()
            
            var y: CGFloat = 40
            
            func draw(_ text: String, size: CGFloat = 14, bold: Bool = false) {
                let font = bold
                ? UIFont.boldSystemFont(ofSize: size)
                : UIFont.systemFont(ofSize: size)
                
                let attrs: [NSAttributedString.Key: Any] = [
                    .font: font
                ]
                
                text.draw(at: CGPoint(x: 40, y: y), withAttributes: attrs)
                y += size + 10
            }
            
            // 🧾 HEADER
            draw("ТЕХНОЛОГИЧЕСКАЯ КАРТА", size: 20, bold: true)
            draw("Дата: \(Date())", size: 12)
            
            y += 10
            
            draw("Наименование: \(semi.name)", size: 16, bold: true)
            draw("Выход: \(Int(semi.outputQuantityInGrams)) г")
            
            y += 15
            
            // 📋 INGREDIENTS
            draw("СОСТАВ:", size: 16, bold: true)
            
            for ing in semi.ingredients {
                draw("• \(ing.name) — \(Int(ing.grams)) г")
            }
            
            y += 15
            
            // 👨‍🍳 TECHNOLOGY
            draw("ТЕХНОЛОГИЯ ПРИГОТОВЛЕНИЯ:", size: 16, bold: true)
            draw(semi.instruction.isEmpty ? "Нет описания" : semi.instruction)
        }
        
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("\(semi.name)_TTK.pdf")
        
        do {
            try data.write(to: url)
            return url
        } catch {
            print("PDF ERROR:", error)
            return nil
        }
    }
    static func exportEmployeeSchedule(employee: WorkEmployee, month: Int, year: Int) -> URL? {
        
        let renderer = UIGraphicsPDFRenderer(
            bounds: CGRect(x: 0, y: 0, width: 595, height: 842)
        )
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        
        let data = renderer.pdfData { ctx in
            ctx.beginPage()
            
            var y: CGFloat = 40
            
            func draw(_ text: String, size: CGFloat = 14, bold: Bool = false) {
                let font = bold
                ? UIFont.boldSystemFont(ofSize: size)
                : UIFont.systemFont(ofSize: size)
                
                let attrs: [NSAttributedString.Key: Any] = [
                    .font: font
                ]
                
                text.draw(at: CGPoint(x: 40, y: y), withAttributes: attrs)
                y += size + 10
            }
            
            // 📄 HEADER
            draw("ГРАФИК РАБОТЫ СОТРУДНИКА", size: 20, bold: true)
            
            draw("ФИО: \(employee.name)", size: 16, bold: true)
            
            let monthName = [
                "Январь","Февраль","Март","Апрель","Май","Июнь",
                "Июль","Август","Сентябрь","Октябрь","Ноябрь","Декабрь"
            ][month - 1]
            
            draw("Месяц: \(monthName) \(year)")
            draw("Дата выгрузки: \(formatter.string(from: Date()))")
            
            y += 10
            
            // 📅 ДНИ
            let key = String(format: "%04d-%02d", year, month)
            let days = employee.monthDays[key, default: []].sorted()
            
            draw("РАБОЧИЕ ДНИ:", size: 16, bold: true)
            
            if days.isEmpty {
                draw("Нет отметок")
            } else {
                draw(days.map { String($0) }.joined(separator: ", "))
            }
            
            y += 15
            
            // 📊 КРАТКАЯ СТАТИСТИКА
            draw("ИТОГО:", size: 16, bold: true)
            draw("Рабочих дней: \(days.count)")
        }
        
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("\(employee.name)_schedule.pdf")
        
        do {
            try data.write(to: url)
            return url
        } catch {
            print("PDF ERROR:", error)
            return nil
        }
    }
    // MARK: - РЕЦЕПТУРА БЛЮДА
    static func exportDish(dish: Dish) -> URL? {
        
        let pageRect = CGRect(
            x: 0,
            y: 0,
            width: 595,
            height: 842
        )
        
        let renderer = UIGraphicsPDFRenderer(
            bounds: pageRect
        )
        
        let data = renderer.pdfData { ctx in
            
            ctx.beginPage()
            
            let cg = ctx.cgContext
            
            var y: CGFloat = 40
            
            // MARK: - HELPERS
            
            func drawText(
                _ text: String,
                x: CGFloat = 40,
                size: CGFloat = 14,
                bold: Bool = false,
                color: UIColor = .black
            ) {
                
                let font = bold
                ? UIFont.boldSystemFont(ofSize: size)
                : UIFont.systemFont(ofSize: size)
                
                let attrs: [NSAttributedString.Key: Any] = [
                    .font: font,
                    .foregroundColor: color
                ]
                
                text.draw(
                    at: CGPoint(x: x, y: y),
                    withAttributes: attrs
                )
                
                y += size + 12
            }
            
            // MARK: - HEADER
            
            let headerRect = CGRect(
                x: 30,
                y: 30,
                width: 535,
                height: 90
            )
            
            cg.setFillColor(
                UIColor(
                    red: 0.95,
                    green: 0.45,
                    blue: 0.15,
                    alpha: 1
                ).cgColor
            )
            
            let path = UIBezierPath(
                roundedRect: headerRect,
                cornerRadius: 24
            )

            cg.addPath(path.cgPath)
            cg.fillPath()
            
            y = 55
            
            drawText(
                "ТЕХНОЛОГИЧЕСКАЯ КАРТА",
                x: 50,
                size: 22,
                bold: true,
                color: .white
            )
            
            drawText(
                dish.name,
                x: 50,
                size: 18,
                bold: true,
                color: .white
            )
            
            y = 140
            
            // MARK: - PHOTO
            
            if let imageData = dish.imageData,
               let image = UIImage(data: imageData) {
                
                let imageRect = CGRect(
                    x: 40,
                    y: y,
                    width: 180,
                    height: 180
                )
                
                image.draw(in: imageRect)
            }
            
            // MARK: - INFO
            
            let infoX: CGFloat = 250
            
            y = 150
            
            drawText(
                "Категория: \(dish.category)",
                x: infoX,
                size: 15,
                bold: true
            )
            
            drawText(
                "Выход: \(Int(dish.outputQuantityInGrams)) г",
                x: infoX,
                size: 15
            )
            
            drawText(
                "Ингредиентов: \(dish.ingredients.count)",
                x: infoX,
                size: 15
            )
            
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            
            drawText(
                "Дата: \(formatter.string(from: Date()))",
                x: infoX,
                size: 15
            )
            
            // MARK: - INGREDIENTS
            
            y = 360
            
            drawText(
                "ИНГРЕДИЕНТЫ",
                size: 18,
                bold: true
            )
            
            y += 10
            
            // TABLE HEADER
            
            let tableWidth: CGFloat = 515
            
            let col1: CGFloat = 350
            let col2: CGFloat = 165
            
            let startX: CGFloat = 40
            
            // HEADER BG
            
            cg.setFillColor(
                UIColor.orange.cgColor
            )
            
            cg.fill(
                CGRect(
                    x: startX,
                    y: y,
                    width: tableWidth,
                    height: 34
                )
            )
            
            // HEADER TEXT
            
            let headerFont = UIFont.boldSystemFont(ofSize: 14)
            
            let headerAttrs: [NSAttributedString.Key: Any] = [
                .font: headerFont,
                .foregroundColor: UIColor.white
            ]
            
            "Продукт".draw(
                at: CGPoint(x: startX + 12, y: y + 8),
                withAttributes: headerAttrs
            )
            
            "Граммы".draw(
                at: CGPoint(x: startX + col1 + 12, y: y + 8),
                withAttributes: headerAttrs
            )
            
            y += 34
            
            // ROWS
            
            for ing in dish.ingredients {
                
                cg.setStrokeColor(
                    UIColor.lightGray.cgColor
                )
                
                cg.stroke(
                    CGRect(
                        x: startX,
                        y: y,
                        width: tableWidth,
                        height: 30
                    )
                )
                
                let attrs: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 13)
                ]
                
                ing.name.draw(
                    at: CGPoint(x: startX + 10, y: y + 7),
                    withAttributes: attrs
                )
                
                "\(Int(ing.grams)) г".draw(
                    at: CGPoint(
                        x: startX + col1 + 10,
                        y: y + 7
                    ),
                    withAttributes: attrs
                )
                
                y += 30
            }
            
            // MARK: - INSTRUCTION
            
            y += 30
            
            drawText(
                "ТЕХНОЛОГИЯ ПРИГОТОВЛЕНИЯ",
                size: 18,
                bold: true
            )
            
            y += 10
            
            let paragraph = NSMutableParagraphStyle()
            paragraph.lineSpacing = 6
            
            let instructionAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 14),
                .paragraphStyle: paragraph
            ]
            
            let instructionRect = CGRect(
                x: 40,
                y: y,
                width: 515,
                height: 300
            )
            
            NSString(
                string: dish.instruction.isEmpty
                ? "Нет описания"
                : dish.instruction
            ).draw(
                in: instructionRect,
                withAttributes: instructionAttrs
            )
        }
        
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent(
                "\(dish.name)_recipe.pdf"
            )
        
        do {
            
            try data.write(to: url)
            
            return url
            
        } catch {
            
            print("PDF ERROR:", error)
            
            return nil
        }
    }
    // MARK: - ORDER PDF

    static func exportOrder(order: Order) -> URL? {
        
        let renderer = UIGraphicsPDFRenderer(
            bounds: CGRect(
                x: 0,
                y: 0,
                width: 595,
                height: 842
            )
        )
        
        let data = renderer.pdfData { ctx in
            
            ctx.beginPage()
            
            var y: CGFloat = 40
            
            func draw(
                _ text: String,
                size: CGFloat = 14,
                bold: Bool = false
            ) {
                
                let font = bold
                ? UIFont.boldSystemFont(ofSize: size)
                : UIFont.systemFont(ofSize: size)
                
                let attrs: [NSAttributedString.Key: Any] = [
                    .font: font
                ]
                
                text.draw(
                    at: CGPoint(x: 40, y: y),
                    withAttributes: attrs
                )
                
                y += size + 12
            }
            
            // HEADER
            
            draw(
                "ЗАКАЗ ПОСТАВЩИКУ",
                size: 24,
                bold: true
            )
            
            draw(
                "Поставщик: \(order.supplier)",
                size: 18,
                bold: true
            )
            
            draw(
                "Дата: \(order.date.formatted())",
                size: 14
            )
            
            y += 20
            
            draw(
                "ПОЗИЦИИ:",
                size: 18,
                bold: true
            )
            
            y += 10
            
            for item in order.items {
                
                draw(
                    "• \(item.productName) — \(item.quantity)"
                )
            }
        }
        
        let url = FileManager.default
            .temporaryDirectory
            .appendingPathComponent(
                "ORDER_\(order.supplier).pdf"
            )
        
        do {
            
            try data.write(to: url)
            
            return url
            
        } catch {
            
            print("ORDER PDF ERROR:", error)
            
            return nil
        }
    }
}
