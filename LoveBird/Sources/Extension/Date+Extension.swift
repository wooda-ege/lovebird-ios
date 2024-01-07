//
//  Date+Extension.swift
//  LoveBird
//
//  Created by 황득연 on 2023/06/25.
//

import Foundation

extension Date {

  // MARK: - Enumeration
  
  enum Format: String {
    case server = "yyyy-MM-dd'T'HH:mm:ss"
    case YMD = "yyyy년 M월 d일"
    case YMDDivided = "yyyy-MM-dd"
    case YMDivided = "yyyy-MM"
    case YMDDotted = "yyyy.MM.dd"
  }

  // MARK: - Initializer

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

  // MARK: - Properties (Int)

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

  // MARK: - Properties (Bool)

  var isToday: Bool {
    return self.year == Date().year && self.month == Date().month && self.day == Date().day
  }

  func isLater(than date: Date) -> Bool {
    return self.compare(date) != .orderedAscending
  }

  // MARK: - Properties (Self)

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

  // MARK: - Date to String

  func to(format: Format) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = format.rawValue
    return formatter.string(from: self)
  }

  // MARK: - Function (Static)

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
