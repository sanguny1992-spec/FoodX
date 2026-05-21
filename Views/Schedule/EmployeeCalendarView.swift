import SwiftUI

struct EmployeeCalendarView: View {
    
    @Binding var employee: WorkEmployee
    var onSave: () -> Void
    
    @State private var selectedMonth = Calendar.current.component(.month, from: Date())
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
    
    @State private var pdfURL: URL?
    @State private var showShare = false
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    var body: some View {
        
        VStack(spacing: 16) {
            
            Text(employee.name)
                .font(.title2)
                .bold()
            
            // 📆 ВЫБОР МЕСЯЦА
            Picker("Месяц", selection: $selectedMonth) {
                ForEach(1...12, id: \.self) { month in
                    Text(monthName(month)).tag(month)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            // 📄 КНОПКА PDF
            Button("Выгрузить PDF") {
                
                pdfURL = TTKPDFExporter.exportEmployeeSchedule(
                    employee: employee,
                    month: selectedMonth,
                    year: selectedYear
                )
                
                if pdfURL != nil {
                    showShare = true
                }
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 5)
            
            // 📅 КАЛЕНДАРЬ
            let key = monthKey()
            let daysInMonth = daysCount(month: selectedMonth, year: selectedYear)
            
            LazyVGrid(columns: columns, spacing: 10) {
                
                ForEach(1...daysInMonth, id: \.self) { day in
                    
                    Text("\(day)")
                        .frame(maxWidth: .infinity, minHeight: 40)
                        .background(
                            isSelected(day, key: key)
                            ? Color.green
                            : Color.gray.opacity(0.2)
                        )
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .onTapGesture {
                            toggle(day, key: key)
                        }
                }
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle("Календарь")
        
        // 📤 SHARE SHEET (ВОТ ЭТО ТЫ НЕ ДОБАВИЛ РАНЬШЕ)
        .sheet(isPresented: $showShare) {
            if let url = pdfURL {
              
            }
        }
    }
    
    // MARK: - логика
    
    private func monthKey() -> String {
        String(format: "%04d-%02d", selectedYear, selectedMonth)
    }
    
    private func daysCount(month: Int, year: Int) -> Int {
        let calendar = Calendar.current
        let date = calendar.date(from: DateComponents(year: year, month: month))!
        return calendar.range(of: .day, in: .month, for: date)!.count
    }
    
    private func isSelected(_ day: Int, key: String) -> Bool {
        employee.monthDays[key, default: []].contains(day)
    }
    
    private func toggle(
        _ day: Int,
        key: String
    ) {

        var days =
            employee.monthDays[key] ?? []

        if days.contains(day) {

            days.removeAll {
                $0 == day
            }

        } else {

            days.append(day)
        }

        employee.monthDays[key] = days

        onSave()
    }
    
    private func monthName(_ month: Int) -> String {
        [
            "Янв",
            "Фев",
            "Март",
            "Апр",
            "Май",
            "Июнь",
            "Июль",
            "Август",
            "Сент",
            "Окт",
            "Нояб",
            "Дек"
        ][month - 1]
    }
}


//
//  EmployeeStorage.swift
//  FoodHelp
//
//  Created by Evgeny on 08.05.2026.
//

import Foundation

