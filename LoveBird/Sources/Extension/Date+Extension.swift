//
//  Date+Extension.swift
//  LoveBird
//
//  Created by 황득연 on 2023/06/25.
//

import Foundation

extension Date {

  // MARK: - Int
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
      return self.month
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
      return self.day
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

  // MARK: - String
  var toYMDFormat: String {
    return "\(self.year)년 \(self.month)월 \(self.day)일"
  }

  // MARK: - Date

  var firstDayOfMonth: Self {
    return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
  }

  var firstDayOfWeek: Self {
    return Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self.firstDayOfMonth))!
  }

  func add(to daysToAdd: Int) -> Self {
    return Calendar.current.date(byAdding: .day, value: daysToAdd, to: self)!
  }

  func isLater(than date: Date) -> Bool {
    return self.compare(date) != .orderedAscending
  }

  // MARK: - static
  static func with(year: Int, month: Int? = nil, day: Int? = nil) -> Self {
    let dateComponents = DateComponents(year: year, month: month, day: day)
    return Calendar.current.date(from: dateComponents)!
  }

  static func dateFormat(date: Date?, time: ScheduleTime?) -> String {
    guard let date = date else { return ""}

    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    guard let time = time else {
      formatter.dateFormat = "yyyy-MM-dd"
      let dateComponents = DateComponents(calendar: .current, year: date.year, month: date.month, day: date.day)
      let dateString = formatter.string(from: dateComponents.date!)
      return dateString
    }
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    let actualHour = time.hour + (time.meridiem == .pm ? 12 : 0)
    let dateComponents = DateComponents(calendar: .current, year: date.year, month: date.month, day: date.day, hour: actualHour, minute: time.minute)
    let dateString = formatter.string(from: dateComponents.date!)
    return dateString
  }
}

// MARK: - Equatable
extension Date {
  static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.year == rhs.year && lhs.month == rhs.month && lhs.day == rhs.day
  }
}
