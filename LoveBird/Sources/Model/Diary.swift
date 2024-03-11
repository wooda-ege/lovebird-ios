//
//  Diary.swift
//  LoveBird
//
//  Created by 황득연 on 12/10/23.
//

struct Diary: Decodable, Equatable, Sendable {
  let diaryId: Int
  let userId: Int
  let title: String
  let memoryDate: String
  let place: String?
  let content: String
  let imageUrls: [String]

  func toHomeDiary(with profile: Profile) -> HomeDiary {
    HomeDiary(
      diaryId: diaryId,
      userId: userId,
      title: title,
      memoryDate: memoryDate,
      place: place,
      content: content,
      imageUrls: imageUrls,
      isMine: profile.userId == userId,
      timeState: .previous,
      type: .diary,
      isFolded: true,
      isTimelineDateShown: true
    )
  }
}

// MARK: - Dummy

extension Diary {
  static let dummy: Self = .init(
    diaryId: 0,
    userId: 0,
    title: "타이틀",
    memoryDate: "2023-09-01",
    place: "장소",
    content: "내용",
    imageUrls: []
  )
}
