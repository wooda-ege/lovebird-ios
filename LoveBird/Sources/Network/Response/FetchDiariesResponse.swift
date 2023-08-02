//
//  FetchDiariesResponse.swift
//  LoveBird
//
//  Created by 황득연 on 2023/08/01.
//

struct FetchDiariesResponse: Decodable, Equatable, Sendable {
  let diarys: [DiaryDTO]
}

struct DiaryDTO: Decodable, Equatable {
  let id: Int
  let memberId: Int
  let title: String
  let memoryDate: String
  let place: String
  let content: String
  let imgUrls: [String]

  func toDomain() -> Diary {
    Diary(
      id: self.id,
      type: .fold,
      year: self.memoryDate.toDate().year,
      month: self.memoryDate.toDate().month,
      day: self.memoryDate.toDate().day,
      weekday: "\(self.memoryDate.toDate().weekday)",
      title: self.title,
      description: self.content,
      location: self.place,
      timeState: .current
    )
  }
}

extension Array where Element == DiaryDTO {
  func toDomain() -> [Diary] {
    self.map {
      $0.toDomain()
    }
  }
}
