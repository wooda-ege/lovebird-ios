//
//  TextFieldState.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/21.
//

import SwiftUI

enum TextFieldState {
  case correct
  case duplicate
  case editing
  case error
  case none
  
  var color: Color {
    switch self {
    case .correct:
      return Color(R.color.primary)
    case .editing:
      return Color(R.color.gray61)
    case .duplicate, .error:
      return Color(R.color.error)
    case .none:
      return Color(R.color.gray214)
    }
  }
  
  var description: String {
    switch self {
    case .correct:
      return "사용 가능한 애칭이에요"
    case .editing:
      return "한글 또는 영어로 2글자 이상 포함해야 해요"
    case .duplicate:
      return "중복된 애칭이에요"
    case .error:
      return "형식이 잘못됐어요"
    case .none:
      return ""
    }
  }
}
