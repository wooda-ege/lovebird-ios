//
//  MonthlySchedule.swift
//  LoveBird
//
//  Created by 황득연 on 12/19/23.
//

import Foundation

struct CalendarMonthly: Equatable, Hashable {
  // Key는 0000-00 이다.
  typealias Schedules = [String: [Schedule]]

  // 0000-00
  let id: String
  var selectedDate: Date
  let dailySchedules: [Schedule]

  static let dummy = CalendarMonthly(id: "", selectedDate: Date(), dailySchedules: [])
}
