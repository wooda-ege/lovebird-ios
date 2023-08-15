//
//  Diaries.swift
//  LoveBird
//
//  Created by 황득연 on 2023/08/01.
//

struct Diaries: Decodable, Equatable, Sendable {
  let diaries: [DiaryDTO]

  enum CodingKeys: String, CodingKey {
    case diaries = "diaryList"
  }
}

struct DiaryDTO: Decodable, Equatable, Sendable {
  let diaryId: Int
  let memberId: Int
  let title: String
  let memoryDate: String
  let place: String?
  let content: String
  let imgUrls: [String]

  func toDiary() -> Diary {
    Diary(
      diaryId: self.diaryId,
      memberId: self.memberId,
      title: self.title,
      memoryDate: self.memoryDate,
      place: self.place,
      content: self.content,
      imgUrls: self.imgUrls
    )
  }
}
