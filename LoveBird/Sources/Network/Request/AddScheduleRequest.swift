//
//  AddCalendarRequest.swift
//  LoveBird
//
//  Created by 황득연 on 2023/07/04.
//

import Foundation

struct AddScheduleRequest: Encodable {
  let title: String
  let memo: String
  let startDate: String
  let endDate: String
}
