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
      return LoveBirdStrings.onboardingGenderMale

    case .female:
      return LoveBirdStrings.onboardingGenderFemale

    case .none:
      return LoveBirdStrings.onboardingGenderPrivate
    }
  }
}
