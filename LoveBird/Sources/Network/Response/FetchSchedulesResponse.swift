//
//  FetchSchedulesResponse.swift
//  LoveBird
//
//  Created by 황득연 on 2023/07/10.
//

struct FetchSchedulesResponse: Decodable, Equatable, Sendable {
  let scheduls: [Schedule]
}
