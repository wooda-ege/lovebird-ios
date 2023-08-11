//
//  String+Extension.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/28.
//

import Foundation
import SwiftUI

extension String {

  // MARK: - Default Properties

  var isNicknameValid: Bool {
    let regEx = "^[ㄱ-ㅎ가-힣a-zA-Z]{0,}$"
    let predicate = NSPredicate(format:"SELF MATCHES %@", regEx)
    return predicate.evaluate(with: self)
  }
  
  var isNotEmpty: Bool {
    return !self.isEmpty
  }

  var isWeekend: Bool {
    return self == "일" || self == "토"
  }

  // MARK: - Date Properties

  // "2023-02-10"
  var year: Int {
    let components = self.components(separatedBy: "-")
    return Int(components[0]) ?? 2023
  }

  var month: Int {
    let components = self.components(separatedBy: "-")
    return Int(components[1]) ?? 1
  }

  var day: Int {
    let components = self.components(separatedBy: "-")
    return Int(components[2]) ?? 1
  }

  func toDate() -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = Date.Format.YMDDivided
    dateFormatter.timeZone = TimeZone(abbreviation: "KST")

    return dateFormatter.date(from: self)!
  }

  // "23:00" -> "오후 11:00"
  func toScheduleTime() -> Self {
    let components = self.components(separatedBy: ":")
    guard components.count == 2 else { return "" }
    let meridiam = Int(components[0])! / 12 == 1 ? "오후" : "오전"
    return "\(meridiam) \((Int(components[0])! + 11) % 12 + 1):\(components[1])"
  }

  // "08:00" -> ScheduleTime(hour: 8, minute: 0, meridiem: .am)
  func toTime() -> ScheduleTime {
    let components = self.components(separatedBy: ":")
    guard components.count == 2 else { return .default }
    let meridiam = Int(components[0])! / 12 == 1 ? "오후" : "오전"
    return .init(hour: (Int(components[0])! + 11) % 12 + 1, minute: Int(components[1])!, meridiem: Int(components[0])! / 12 == 1 ? .pm : .am)
  }

  // "PRIMARY" -> ScheduleColor(.primary)
  func toColor() -> ScheduleColor {
    switch self {
    case "SECONDARY":
      return .secondary
    case "PRIMARY":
      return .primary
    case "GRAY":
      return .gray
    default:
      return .none
    }
  }

  // MARK: - Static Method

  static func toScheduleDateWith(
    date: String,
    startTime: String?,
    endTime: String?
  ) -> String {
    let date = date.toDate().to(dateFormat: Date.Format.YMD)
    if let startTime = startTime, let endTime = endTime {
      if startTime == endTime {
        return "\(date) \(startTime.toScheduleTime())"
      }
      return "\(date) \(startTime.toScheduleTime()) ~ \(endTime.toScheduleTime())"
    }
    return date
  }

  static func intervalDates(startDate: String, endDate: String) -> [String] {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.timeZone = TimeZone(abbreviation: "KST")

    guard let startDate = dateFormatter.date(from: startDate),
          let endDate = dateFormatter.date(from: endDate) else {
        fatalError("Invalid dates")
    }

    var date = startDate
    var dates: [String] = []

    while date <= endDate {
        dates.append(dateFormatter.string(from: date))

        guard let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else {
            break
        }

        date = nextDate
    }
    return dates
  }
}

