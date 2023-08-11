//
//  Schedules.swift
//  LoveBird
//
//  Created by 황득연 on 2023/07/10.
//

struct Schedules: Decodable, Equatable, Sendable {
  let schedules: [Schedule]

  enum CodingKeys: String, CodingKey {
    case schedules = "calendarList"
  }
}
