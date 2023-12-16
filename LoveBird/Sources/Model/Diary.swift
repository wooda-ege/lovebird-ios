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

  func toDiary(with profile: Profile) -> HomeDiary {
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
