//
//  Date+Properties.swift
//  LoveBird
//
//  Created by 황득연 on 2023/07/10.
//

import Foundation

extension Date {

  init?(from string: String) {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(abbreviation: "KST")

    if string.count == 7 { // "년-월" 형식 확인 (예: "2023-09")
      dateFormatter.dateFormat = Date.Format.YMDivided.rawValue
      guard let date = dateFormatter.date(from: string) else { return nil }
      self.init(timeInterval: 0, since: date)
    } else if string.count == 10 { // "년-월-일" 형식 확인 (예: "2023-09-02")
      dateFormatter.dateFormat = Date.Format.YMDDivided.rawValue
      guard let date = dateFormatter.date(from: string) else { return nil }
      self.init(timeInterval: 0, since: date)
    } else {
      return nil
    }
  }

//  init(from string: String) {
//    let dateFormatter = DateFormatter()
//    dateFormatter.timeZone = TimeZone(abbreviation: "KST")
//
//    // "년-월-일" 형식
//    if string.count == 10 {
//      dateFormatter.dateFormat = Date.Format.YMDDivided.rawValue
//      if let date = dateFormatter.date(from: string) {
//        self = date
//        return
//      }
//    }
//
//    // "년-월" 형식
//    else if string.count == 7 {
//      dateFormatter.dateFormat = Date.Format.YMDivided.rawValue
//      if let date = dateFormatter.date(from: string) {
//        self = date
//        return
//      }
//    }
//
//    self = Date()
//  }

  // MARK: - Int Properties

  var year: Int {
    return Calendar.current.component(.year, from: self)
  }

  var month: Int {
    return Calendar.current.component(.month, from: self)
  }

  var day: Int {
    return Calendar.current.component(.day, from: self)
  }

  var weekday: Int {
    return Calendar.current.component(.weekday, from: self)
  }

  var previousMonth: Int {
    return Calendar.current.date(byAdding: .month, value: -1, to: self)!.month
  }

  var followingMonth: Int {
    return Calendar.current.date(byAdding: .month, value: 1, to: self)!.month
  }

  var calculateMonths: Int {
    if self.year == Self().year {
      return Self().month
    } else {
      return 12
    }
  }

  var calculateDays: Int {
    let dateComponents = DateComponents(year: self.year, month: self.month)
    if let date = Calendar.current.date(from: dateComponents) {
      let range = Calendar.current.range(of: .day, in: .month, for: date)
      return range?.count ?? 31
    } else {
      return 31
    }
  }

  var calculateDaysInOnBoarding: Int {
    if self.year == Self().year, self.month == Self().month {
      return Self().day
    }
    let dateComponents = DateComponents(year: self.year, month: self.month)
    if let date = Calendar.current.date(from: dateComponents) {
      let range = Calendar.current.range(of: .day, in: .month, for: date)
      return range?.count ?? 31
    } else {
      return 31
    }
  }

  var numberOfWeeksInMonth: Int {
    return Calendar.current.range(of: .weekOfMonth, in: .month, for: self)!.count
  }

  // MARK: - Bool Properties

  var isToday: Bool {
    return self.year == Date().year && self.month == Date().month && self.day == Date().day
  }

  func isLater(than date: Date) -> Bool {
    return self.compare(date) != .orderedAscending
  }

  // MARK: - Self Properties

  var firstDayOfMonth: Self {
    let calendar = Calendar.current
    var components = calendar.dateComponents([.year, .month, .timeZone], from: self)
    components.timeZone = TimeZone(identifier: "Asia/Seoul")
    components.day = 1
    return calendar.date(from: components) ?? Date()
  }

  var firstDayOfWeek: Self {
    return Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self.firstDayOfMonth))!
  }

  func addDays(by daysToAdd: Int) -> Self {
    return Calendar.current.date(byAdding: .day, value: daysToAdd, to: self)!
  }

  func addMonths(by monthsToAdd: Int) -> Self {
    return Calendar.current.date(byAdding: .month, value: monthsToAdd, to: self)!
  }
}
