//
//  Profile.swift
//  LoveBird
//
//  Created by 황득연 on 2023/08/05.
//

import Foundation

struct Profile: Equatable, Codable, Sendable {
  struct Anniversary: Codable, Equatable {
    enum Kind: String, Codable, Equatable {
      case day = "DAY"
      case year = "YEAR"

      var description: String {
        switch self {
        case .day:
          return "일"
        case .year:
          return "주년"
        }
      }
    }

    let kind: Kind
    let seq: Int
    let anniversaryDate: String

    var name: String { "\(seq)\(kind.description)" }
  }

  let userId: Int
  let partnerId: Int?
  let email: String
  let nickname: String
  let partnerNickname: String?
  let firstDate: String?
  let birthDay: String?
  let dayCount: Int?
  let nextAnniversary: Anniversary?
  let profileImageUrl: String?
  let partnerImageUrl: String?

  var isLinked: Bool {
    partnerId.isNotNil && partnerNickname.isNotNil
  }

  func authorName(with id: Int) -> String? {
    if id == userId { return nickname }
    else { return partnerNickname }
  }
}

// MARK: - Dummy

extension Profile {
  static let dummy: Self =
    .init(
      userId: 0,
      partnerId: 1,
      email: "test@lb.com",
      nickname: "러브",
      partnerNickname: "버드",
      firstDate: "2022-01-01",
      birthDay: "1995-06-24",
      dayCount: 200,
      nextAnniversary: .init(kind: .day, seq: 200, anniversaryDate: "2024-10-31"),
      profileImageUrl: nil,
      partnerImageUrl: nil
    )
}
