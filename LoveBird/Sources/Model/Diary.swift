//
//  Diary.swift
//  LoveBird
//
//  Created by 황득연 on 12/10/23.
//

struct Diary: Decodable, Equatable, Sendable {
  let diaryId: Int
  let memberId: Int
  let title: String
  let memoryDate: String
  let place: String?
  let content: String
  let imgUrls: [String]

  func toHomeDiary(with profile: Profile) -> HomeDiary {
    HomeDiary(
      diaryId: diaryId,
      memberId: memberId,
      title: title,
      memoryDate: memoryDate,
      place: place,
      content: content,
      imgUrls: imgUrls,
      isMine: profile.memberId == memberId,
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
    memberId: 0,
    title: "타이틀",
    memoryDate: "2023-09-01",
    place: "장소",
    content: "내용",
    imgUrls: []
  )
}
