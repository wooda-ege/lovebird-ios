//
//  CalendarDate.swift
//  LoveBird
//
//  Created by 황득연 on 2023/06/27.
//

import Foundation

enum CalendarDate: Equatable {
  case previous(date: Date)
  case current(date: Date)
  case following(date: Date)

  var date: Date {
    switch self {
    case .previous(let date), .current(let date), .following(let date):
      return date
    }
  }

  var isThisMonth: Bool {
    switch self {
    case .current:
      return true
    default:
      return false
    }
  }

  var isToday: Bool {
    switch self {
    case .current(let date):
      return date.isToday
    default:
      return false
    }
  }
}
