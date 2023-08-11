//
//  ScheduleAlarm.swift
//  LoveBird
//
//  Created by 황득연 on 2023/07/02.
//

import Foundation

enum ScheduleAlarm: Encodable, CaseIterable {
  case typeA
  case typeB
  case typeC
  case typeD
  case typeE
  case typeF
  case typeG
  case typeH
  case none

  var description: String {
    switch self {
    case .typeA:
      return "일정 당시"
    case .typeB:
      return "5분 전"
    case .typeC:
      return "15분 전"
    case .typeD:
      return "30분 전"
    case .typeE:
      return "1시간 전"
    case .typeF:
      return "2시간 전"
    case .typeG:
      return "1일 전"
    case .typeH:
      return "2일 전"
    case .none:
      return ""
    }
  }
}
