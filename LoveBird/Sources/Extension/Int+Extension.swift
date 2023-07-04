//
//  Int+Extension.swift
//  LoveBird
//
//  Created by 황득연 on 2023/07/02.
//

import Foundation

extension Int {
  var toAddScheduleMinuteFormat: String {
    let formatter = NumberFormatter()
    formatter.minimumIntegerDigits = 2
    let minute = String(describing: formatter.string(from: NSNumber(value: self))!)
    return minute
  }
}
