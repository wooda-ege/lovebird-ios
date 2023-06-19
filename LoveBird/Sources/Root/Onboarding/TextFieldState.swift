//
//  TextFieldState.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/21.
//

import SwiftUI

enum TextFieldState {
  case correct
  case editing
  case error
  case none
  
  var color: Color {
    switch self {
    case .correct:
      return Color(R.color.primary)
    case .editing:
      return Color(R.color.gray10)
    case .error:
      return Color(R.color.error)
    case .none:
      return Color(R.color.gray05)
    }
  }
  
  var description: String {
    switch self {
    case .correct:
      return String(resource: R.string.localizable.onboarding_nickname_correct)
    case .editing:
      return String(resource: R.string.localizable.onboarding_nickname_edit)
    case .error:
      return String(resource: R.string.localizable.onboarding_nickname_error)
    case .none:
      return ""
    }
  }
}
