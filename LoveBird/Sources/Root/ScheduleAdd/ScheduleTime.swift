//
//  AddScheduleTime.swift
//  LoveBird
//
//  Created by 황득연 on 2023/07/01.
//

import Foundation

struct ScheduleTime: Equatable {

  enum Meridiem: String {
    case am = "오전"
    case pm = "오후"
  }
  
  var hour: Int
  var minute: Int
  var meridiem: Meridiem

  var format: String {
    let formatter = NumberFormatter()
    formatter.minimumIntegerDigits = 2
    let hour = String(describing: formatter.string(from: NSNumber(value: self.hour))!)
    let minute = String(describing: formatter.string(from: NSNumber(value: self.minute))!)
    return "\(self.meridiem.rawValue) \(hour):\(minute)"
  }

  func isLater(than time: ScheduleTime) -> Bool {
    if self.meridiem == time.meridiem {
      if self.hour > time.hour {
        return true
      } else if self.hour == time.hour, self.minute > time.minute {
        return true
      }
    } else if self.meridiem == .pm {
      return true
    }
    return false
  }

  func addOneHour() -> Self {
    if self.hour == 11 {
      if self.meridiem == .am {
        return Self(hour: 12, minute: self.minute, meridiem: .pm)
      } else {
        return Self(hour: 11, minute: 59, meridiem: self.meridiem)
      }
    } else {
      return Self(hour: self.hour % 12 + 1, minute: self.minute, meridiem: self.meridiem)
    }
  }

  func subtractOneHour() -> Self {
    if self.hour == 12 {
      if self.meridiem == .pm {
        return Self(hour: 11, minute: self.minute, meridiem: .am)
      } else {
        return Self(hour: 12, minute: 0, meridiem: self.meridiem)
      }
    } else {
      return Self(hour: (self.hour + 11) % 12, minute: self.minute, meridiem: self.meridiem)
    }
  }
}
