//
//  Date+Properties.swift
//  LoveBird
//
//  Created by 황득연 on 2023/07/10.
//

import Foundation

extension Date {

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

  var calculateWeekOfMonth: Int {
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
    return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
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
