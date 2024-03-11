//
//  HomeDiary.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/27.
//

import Foundation
import UIKit
import SwiftUI

struct HomeDiary: Decodable, Equatable, Sendable {

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
  let userId: Int
  var title: String
  var memoryDate: String
  var place: String?
  var content: String
  var imageUrls: [String]
  let isMine: Bool
  var timeState: TimeState
  var type: HomeItem.ContentType
  var isFolded: Bool
  var isTimelineDateShown: Bool

  func toDiary() -> Diary {
    Diary(
      diaryId: self.diaryId,
      userId: self.userId,
      title: self.title,
      memoryDate: self.memoryDate,
      place: self.place,
      content: self.content,
      imageUrls: self.imageUrls
    )
  }
}

// MARK: - Getters (static)

extension HomeDiary {
  static func initialDiary(with date: String) -> Self {
    Self (
      diaryId: IDs.INITIAL.rawValue,
      userId: 0,
      title: "",
      memoryDate: date,
      place: "",
      content: "",
      imageUrls: [],
      isMine: true,
      timeState: .previous,
      type: .initial,
      isFolded: true,
      isTimelineDateShown: true
    )
  }

  static func todoDiary(with date: String) -> Self {
    Self(
      diaryId: IDs.TODO.rawValue,
      userId: 0,
      title: "오늘 데이트 기록하기",
      memoryDate: date,
      place: "",
      content: "",
      imageUrls: [],
      isMine: true,
      timeState: .current,
      type: .empty,
      isFolded: true,
      isTimelineDateShown: true
    )
  }

  static func anniversaryDiary(with date: String, title: String) -> Self {
    Self(
      diaryId: IDs.ANNIVERSARY.rawValue,
      userId: 0,
      title: title,
      memoryDate: date,
      place: "",
      content: "",
      imageUrls: [],
      isMine: true,
      timeState: .following,
      type: .anniversary,
      isFolded: true,
      isTimelineDateShown: true
    )
  }
}

// MARK: - Dummy

extension HomeDiary {
  static let dummy: Self = .init(
    diaryId: 0,
    userId: 0,
    title: "타이틀",
    memoryDate: "2023-09-01",
    place: "장소",
    content: "내용",
    imageUrls: [],
    isMine: true,
    timeState: .previous,
    type: .diary,
    isFolded: false,
    isTimelineDateShown: true
  )
}
