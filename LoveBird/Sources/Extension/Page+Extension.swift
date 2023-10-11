//
//  Page+Extension.swift
//  LoveBird
//
//  Created by 황득연 on 2023/06/18.
//

import SwiftUIPager

extension Page {
  enum Onboarding: Int, CaseIterable {
    case nickname
    case profileImage
    case birth
    case gender
    case anniversary

    var title: String {
      switch self {
      case .nickname:
        return String(resource: R.string.localizable.onboarding_nickname_title)
      case .profileImage:
        return String(resource: R.string.localizable.onboarding_profile_title)
      case .birth:
        return String(resource: R.string.localizable.onboarding_birthdate_title)
      case .gender:
        return String(resource: R.string.localizable.onboarding_gender_title)
      case .anniversary:
        return String(resource: R.string.localizable.onboarding_date_title)
      }
    }

    var description: String {
      switch self {
      case .nickname:
        return String(resource: R.string.localizable.onboarding_nickname_description)
      case .profileImage:
        return String(resource: R.string.localizable.onboarding_profile_description)
      case .birth:
        return String(resource: R.string.localizable.onboarding_birthdate_description)
      case .gender:
        return String(resource: R.string.localizable.onboarding_gender_description)
      case .anniversary:
        return String(resource: R.string.localizable.onboarding_date_description)
      }
    }

    var canSkip: Bool {
      return self == .birth || self == .profileImage || self == .anniversary
    }
  }

  var state: Onboarding {
    return Onboarding(rawValue: self.index) ?? .nickname
  }

  var isFisrt: Bool {
    return self.index == Onboarding.nickname.rawValue
  }

  var isLast: Bool {
    return self.index == Onboarding.anniversary.rawValue
  }
}

extension Page: Equatable {
  // Page가 Class이므로 사실상 true만 return된다.
  public static func == (lhs: Page, rhs: Page) -> Bool {
    lhs.index == rhs.index
  }
}
