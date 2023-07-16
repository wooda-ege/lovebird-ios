//
//  Date+Extension.swift
//  LoveBird
//
//  Created by 황득연 on 2023/06/25.
//

import Foundation

extension Date {

  enum Format {
    static let `default` = "yyyy-MM-dd'T'HH:mm:ss"
    static let YMD = "yyyy년 M월 d일"
  }

  // MARK: - String Properties

  var toYMDFormat: String {
    return "\(self.year)년 \(self.month)월 \(self.day)일"
  }

  // MARK: - Transform

  func to(dateFormat: String) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = dateFormat
    return formatter.string(from: self)
  }

  // MARK: - Static Function

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

enum DateFormat: String {
  case `default` = "yyyy-MM-dd'T'HH:mm:ss"
}
