//
//  AddCalendarRequest.swift
//  LoveBird
//
//  Created by 황득연 on 2023/07/04.
//

import Foundation

public struct AddScheduleRequest {
  let id: Int?
  let title: String
  let memo: String?
  let color: ScheduleColor
  let alarm: ScheduleAlarm?
  let startDate: String
  let endDate: String?
  let startTime: String?
  let endTime: String?
}
