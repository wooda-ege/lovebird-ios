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
  public static func == (lhs: Page, rhs: Page) -> Bool {
    lhs.index == rhs.index
  }
}
