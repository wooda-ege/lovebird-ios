//
//  Schedule.swift
//  LoveBird
//
//  Created by 황득연 on 2023/07/10.
//

struct Schedule: Equatable, Decodable {
  let id: Int
  let startDate: String
  let endDate: String
  let startTime: String?
  let endTime: String?
  let title: String
  let memo: String
  let color: String = "Second"

  static let dummy: [Schedule] = [
    .init(id: 1, startDate: "2023-07-02", endDate: "2023-07-03", startTime: "7:00", endTime: "21:00", title: "TestTitle1", memo: "TestMemo1"),
    .init(id: 2, startDate: "2023-07-03", endDate: "2023-07-03", startTime: nil, endTime: nil, title: "TestTitle1", memo: "TestMemo1"),
    .init(id: 3, startDate: "2023-07-05", endDate: "2023-07-05", startTime: "7:00", endTime: "21:00", title: "TestTitle2", memo: "TestMemo2"),
    .init(id: 4, startDate: "2023-07-19", endDate: "2023-07-22", startTime: "7:00", endTime: "21:00", title: "TestTitle3", memo: "TestMemo")
  ]
}

extension Array<Schedule> {
  func mapToDict() -> [String: [Schedule]] {
    var dict = [String: [Schedule]]()
    self.forEach { schedule in
      let dates = String.intervalDates(startDate: schedule.startDate, endDate: schedule.endDate)
      dates.forEach { dateOfRange in
        dict[dateOfRange] = dict[dateOfRange, default: []] + [schedule]
        print("---------------")
        print(dateOfRange)
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
