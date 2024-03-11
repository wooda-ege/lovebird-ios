//
//  Schedule.swift
//  LoveBird
//
//  Created by 황득연 on 2023/07/10.
//

struct Schedule: Decodable, Equatable, Hashable {
  let id: Int
  let userId: Int
  let startDate: String
  let endDate: String?
  let startTime: String?
  let endTime: String?
  let title: String
  let memo: String?
  let color: ScheduleColor
  let alarm: ScheduleAlarm?
}

// MARK: - Dummy

extension Schedule {
  static let dummy: Self = .init(
    id: 0,
    userId: 0,
    startDate: "2023-09-01",
    endDate: "2023-09-03",
    startTime: "18:00:00",
    endTime: "22:00:00",
    title: "타이틀",
    memo: "메모",
    color: .primary,
    alarm: .typeB
  )
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

