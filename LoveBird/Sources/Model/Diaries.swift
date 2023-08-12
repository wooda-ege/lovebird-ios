//
//  Diaries.swift
//  LoveBird
//
//  Created by 황득연 on 2023/08/01.
//

struct Diaries: Decodable, Equatable, Sendable {
  let diaries: [Diary]

  enum CodingKeys: String, CodingKey {
    case diaries = "diaryList"
  }
}
