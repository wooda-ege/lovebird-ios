//
//  Page+Extension.swift
//  LoveBird
//
//  Created by 황득연 on 2023/06/18.
//

import SwiftUIPager

extension Page {
  enum Onboarding: Int, CaseIterable {
    case email
    case nickname
    case profileImage
    case birth
    case gender
    case anniversary

    var title: String {
      switch self {
      case .email:
        return LoveBirdStrings.onboardingEmailTitle
      case .nickname:
        return LoveBirdStrings.onboardingNicknameTitle
      case .profileImage:
        return LoveBirdStrings.onboardingProfileTitle
      case .birth:
        return LoveBirdStrings.onboardingBirthdateTitle
      case .gender:
        return LoveBirdStrings.onboardingGenderTitle
      case .anniversary:
        return LoveBirdStrings.onboardingDateTitle
      }
    }

    var description: String {
      switch self {
      case .email:
        return LoveBirdStrings.onboardingEmailDescription
      case .nickname:
        return LoveBirdStrings.onboardingNicknameDescription
      case .profileImage:
        return LoveBirdStrings.onboardingProfileDescription
      case .birth:
        return LoveBirdStrings.onboardingBirthdateDescription
      case .gender:
        return LoveBirdStrings.onboardingGenderDescription
      case .anniversary:
        return LoveBirdStrings.onboardingDateDescription
      }
    }

    var canSkip: Bool {
      return self == .birth || self == .profileImage || self == .anniversary
    }
  }

  var state: Onboarding {
    return Onboarding(rawValue: self.index) ?? .email
  }

  var isFisrt: Bool {
    return self.index == Onboarding.email.rawValue
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
