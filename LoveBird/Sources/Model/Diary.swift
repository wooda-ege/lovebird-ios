//
//  Diary.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/27.
//

import Foundation
import UIKit
import SwiftUI

struct Diary: Decodable, Equatable, Sendable {

  enum IDs: Int {
    case INITIAL = -1
    case TODO = -2
    case ANNIVERSARY = -3
  }

  enum TimeState: Decodable, Equatable, Sendable {
    case previous
    case current
    case following
  }

  let diaryId: Int
  let memberId: Int
  let title: String
  let memoryDate: String
  let place: String?
  let content: String
  let imgUrls: [String]
  var timeState: TimeState = .previous
  var type: HomeItem.ContentType = .diary
  var isFolded: Bool = true
  var isTimelineDateShown = true
}

// MARK: - Properties

extension Diary {
  static func initialDiary(with date: String) -> Self {
    Self (
      diaryId: IDs.INITIAL.rawValue,
      memberId: 0,
      title: "",
      memoryDate: date,
      place: "",
      content: "",
      imgUrls: [],
      timeState: .previous,
      type: .initial,
      isFolded: false
    )
  }

  static func todoDiary(with date: String) -> Self {
    Self(
      diaryId: IDs.TODO.rawValue,
      memberId: 0,
      title: "오늘 데이트 기록하기",
      memoryDate: date,
      place: "",
      content: "",
      imgUrls: [],
      timeState: .current,
      type: .empty
    )
  }

  static func anniversaryDiary(with date: String, title: String) -> Self {
    Self(
      diaryId: IDs.ANNIVERSARY.rawValue,
      memberId: 0,
      title: title,
      memoryDate: date,
      place: "",
      content: "",
      imgUrls: [],
      timeState: .following,
      type: .anniversary
    )
  }
}
