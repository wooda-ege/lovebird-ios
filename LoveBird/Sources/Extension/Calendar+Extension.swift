//
//  Calendar+Extension.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/29.
//

import Foundation

extension Calendar {
    static var year: Int {
        return self.current.component(.year, from: Date())
    }
    
    static var month: Int {
        return self.current.component(.month, from: Date())
    }
    
    static var day: Int {
        return self.current.component(.day, from: Date())
    }
    
    static func calculateMonths(in year: Int) -> Int {
        if year == Calendar.year {
            return Calendar.month
        } else {
            return 12
        }
    }
    
    static func calculateDays(in month: Int, year: Int) -> Int {
        if year == Calendar.year, month == Calendar.month {
            return Calendar.day
        }
        let dateComponents = DateComponents(year: year, month: month)
        if let date = self.current.date(from: dateComponents) {
            let range = self.current.range(of: .day, in: .month, for: date)
            return range?.count ?? 31
        } else {
            return 31
        }
    }
}
