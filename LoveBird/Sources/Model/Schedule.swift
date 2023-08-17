//
//  Schedule.swift
//  LoveBird
//
//  Created by 황득연 on 2023/07/10.
//

struct Schedule: Decodable, Equatable, Sendable {
  let id: Int
  let memberId: Int
  let startDate: String
  let endDate: String?
  let startTime: String?
  let endTime: String?
  let title: String
  let memo: String?
  let color: ScheduleColor
  let alarm: AlarmType?

  static let aDummy: Self = .init(id: 0, memberId: 0, startDate: "", endDate: "", startTime: "", endTime: "", title: "", memo: "", color: .primary, alarm: .none)
}

enum AlarmType: String, Decodable, Equatable {
  case typeA = "TYPE_A"
  case typeB = "TYPE_B"
  case typeC = "TYPE_C"
  case typeD = "TYPE_D"
  case typeE = "TYPE_E"
  case typeF = "TYPE_F"
  case typeG = "TYPE_G"
  case none = "NONE"

  var description: String {
    switch self {
    case .typeA:
      return "5분 전"
    case .typeB:
      return "15분 전"
    case .typeC:
      return "30분 전"
    case .typeD:
      return "1시간 전"
    case .typeE:
      return "2시간 전"
    case .typeF:
      return "1일 전"
    case .typeG:
      return "2일 전"
    case .none:
      return "알림 없음"
    }
  }
}

extension Array<Schedule> {
  func mapToDict() -> [String: [Schedule]] {
    var dict = [String: [Schedule]]()
    self.forEach { schedule in
      let dates = String.intervalDates(startDate: schedule.startDate, endDate: schedule.endDate ?? schedule.startDate)
      dates.forEach { dateOfRange in
        dict[dateOfRange] = dict[dateOfRange, default: []] + [schedule]
      }
    }
    return dict
  }
}

struct SchedulesOnDay: Equatable {
  let id: Int
  let day: Int
  let schedules: [Schedule]
}
