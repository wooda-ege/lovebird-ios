//
//  Profile.swift
//  LoveBird
//
//  Created by 황득연 on 2023/08/05.
//

import Foundation

struct Profile: Equatable, Codable, Sendable {
  let memberId: Int
  let partnerId: Int?
  let email: String
  let nickname: String
  let partnerNickname: String?
  let firstDate: String
  let birthDay: String?
  let dayCount: Int
  let nextAnniversary: Anniversary
  let profileImageUrl: String?
  let partnerImageUrl: String?

  struct Anniversary: Codable, Equatable {
    let kind: DateMilestone
    let anniversaryDate: String
  }

  enum DateMilestone: String, Codable, Equatable {
    case oneHundred = "ONE_HUNDRED"
    case twoHundreds = "TWO_HUNDREDS"
    case threeHundreds = "THREE_HUNDREDS"
    case oneYear = "ONE_YEAR"
    case twoYears = "TWO_YEARS"
    case threeYears = "THREE_YEARS"
    case fourYears = "FOUR_YEARS"
    case fiveYears = "FIVE_YEARS"
    case sixYears = "SIX_YEARS"
    case sevenYears = "SEVEN_YEARS"
    case eightYears = "EIGHT_YEARS"
    case nineYears = "NINE_YEARS"
    case tenYears = "TEN_YEARS"

    var description: String {
      switch self {
      case .oneHundred:
        return "백일"
      case .twoHundreds:
        return "이백일"
      case .threeHundreds:
        return "삼백일"
      case .oneYear:
        return "1주년"
      case .twoYears:
        return "2주년"
      case .threeYears:
        return "3주년"
      case .fourYears:
        return "4주년"
      case .fiveYears:
        return "5주년"
      case .sixYears:
        return "6주년"
      case .sevenYears:
        return "7주년"
      case .eightYears:
        return "8주년"
      case .nineYears:
        return "9주년"
      case .tenYears:
        return "10주년"
      }
    }
  }
}
