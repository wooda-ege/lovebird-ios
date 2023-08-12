//
//  DateFormatter+Extension.swift
//  LoveBird
//
//  Created by 황득연 on 2023/06/25.
//

import Foundation

extension DateFormatter {
  static func daysOfWeek() -> [String] {
    let dateFormatter = Self()
    dateFormatter.locale = Locale(identifier: "ko_KR")
    return dateFormatter.shortWeekdaySymbols
  }
}
