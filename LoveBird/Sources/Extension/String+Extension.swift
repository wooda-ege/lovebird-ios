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
    let dateFormatter = ISO8601DateFormatter()
    dateFormatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
    dateFormatter.timeZone = TimeZone(abbreviation: "KST")

    return dateFormatter.date(from: self)!
  }

  static func toScheduleDateWith(startDate: String, endDate: String?) -> String {
    let start = startDate.toDate().to(dateFormat: Date.Format.YMD)
    if let endDate = endDate {
      let end = endDate.toDate().to(dateFormat: Date.Format.YMD)
      return "\(start) - \(end)"
    } else {
      return start
    }
  }
}

