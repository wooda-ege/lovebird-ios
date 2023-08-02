//
//  Schedule.swift
//  LoveBird
//
//  Created by 황득연 on 2023/07/10.
//

struct Schedule: Hashable, Decodable {
  let id: Int
  let title: String
  let memo: String
  let startDate: String
  let endDate: String
  let startTime: String?
  let endTime: String?
  let color: String
  let alarm: String

  static let dummy: [Schedule] = [
    .init(id: 1, title: "가", memo: "가나다라", startDate: "2023-07-16", endDate: "2023-07-17", startTime: "15:00", endTime: "17:00", color: "PRIMARY", alarm: "TYPE_G"),
    .init(id: 10, title: "sk", memo: "가나다라11", startDate: "2023-07-16", endDate: "2023-07-17", startTime: "15:00", endTime: "17:00", color: "PRIMARY", alarm: "TYPE_G"),
    .init(id: 2, title: "다", memo: "ㄴ댜ㅓ릴ㄷㄹㄴㄷㄹㄴㄷㄹㄴㄷㄹ", startDate: "2023-07-19", endDate: "2023-07-19", startTime: "15:00", endTime: "17:00", color: "SECONDARY", alarm: "TYPE_G"),
    .init(id: 3, title: "다ㄴㄷ더", memo: "ㄴ댜ㅓ", startDate: "2023-07-19", endDate: "2023-07-19", startTime: nil, endTime: nil, color: "PRIMARY", alarm: "TYPE_A")
  ]

  static let aDummy: Schedule = .init(id: 1, title: "가", memo: "가나다라", startDate: "2023-07-16", endDate: "2023-07-17", startTime: "15:00", endTime: "17:00", color: "PRIMARY", alarm: "TYPE_G")
}

extension Array<Schedule> {
  func mapToDict() -> [String: [Schedule]] {
    var dict = [String: [Schedule]]()
    self.forEach { schedule in
      let dates = String.intervalDates(startDate: schedule.startDate, endDate: schedule.endDate)
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
