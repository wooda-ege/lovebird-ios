//
//  ScheduleAddFocusedType.swift
//  LoveBird
//
//  Created by 황득연 on 2023/06/30.
//

import Foundation

enum ScheduleAddFocusedType: Equatable {

  enum TimeType {
    case start
    case end
    case none
  }
  case title
  case color
  case startDate
  case endDate
  case time
  case startTime
  case endTime
  case alarm
  case memo
  case none

  var isTime: Bool {
    return self == .time || self == .startTime || self == .endTime
  }
}
