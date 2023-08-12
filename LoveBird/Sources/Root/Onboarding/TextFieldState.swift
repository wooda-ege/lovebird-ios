//
//  TextFieldState.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/21.
//

import SwiftUI

enum TextFieldState {
  case nicknameCorrect
  case emailCorrect
  case duplicate
  case editing
  case error
  case emailError
  case none
  
  var color: Color {
    switch self {
    case .nicknameCorrect, .emailCorrect:
      return Color(R.color.primary)
    case .editing:
      return Color(R.color.gray10)
    case .duplicate, .error, .emailError:
      return Color(R.color.error)
    case .none:
      return Color(R.color.gray05)
    }
  }
  
  var description: String {
    switch self {
    case .nicknameCorrect:
      return "사용 가능한 애칭이에요"
    case .emailCorrect:
      return "올바른 형식의 이메일이에요"
    case .editing:
      return "한글 또는 영어 2-20글자 이내로 입력해 주세요"
    case .duplicate:
      return "중복된 애칭이에요"
    case .emailError:
      return "love@bird.com와 같은 형식으로 입력해 주세요"
    case .error:
      return String(resource: R.string.localizable.onboarding_nickname_error)
    case .none:
      return ""
    }
  }
}

enum ButtonClickState {
  case clicked
  case notClicked
}
