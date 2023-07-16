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
  let title: String
  let memo: String
}
