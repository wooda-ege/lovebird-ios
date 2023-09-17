//
//  Gender.swift
//  LoveBird
//
//  Created by 황득연 on 2023/09/17.
//

import Foundation

enum Gender: String, CaseIterable {
  case male = "MALE"
  case female = "FEMALE"
  case none = "UNKNOWN"

  var description: String {
    switch self {
    case .male:
      return String(resource: R.string.localizable.onboarding_gender_male)

    case .female:
      return String(resource: R.string.localizable.onboarding_gender_female)

    case .none:
      return String(resource: R.string.localizable.onboarding_gender_private)
    }
  }
}
