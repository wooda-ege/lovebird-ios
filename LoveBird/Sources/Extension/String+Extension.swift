//
//  String+Extension.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/28.
//

import Foundation

extension String {
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

  func toDate() -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = Date.Format.dictionKey
    dateFormatter.timeZone = TimeZone(abbreviation: "KST")

    return dateFormatter.date(from: self)!
  }

  func toScheduleTime() -> Self {
    let components = self.components(separatedBy: ":")
    let meridiam = Int(components[0])! / 12 == 1 ? "오후" : "오전"
    return "\(meridiam) \((Int(components[0])! + 11) % 12 + 1):\(components[1])"
  }

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

