//
//  TextFieldState.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/21.
//

import SwiftUI

enum TextFieldState: Equatable {

  enum `Type`: Equatable {
    case email, nickname
  }

  case correct(`Type`)
  case editing(`Type`)
  case error(`Type`)
  case none

  var isCorrect: Bool {
    switch self {
    case .correct:
      return true
    default:
      return false
    }
  }

  var isEditing: Bool {
    switch self {
    case .editing:
      return true
    default:
      return false
    }
  }
  
  var isError: Bool {
    switch self {
    case .error:
      return true
    default:
      return false
    }
  }
  
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
    case .correct(let type):
      switch type {
      case .email:
        return "올바른 형식의 이메일이에요"
      case .nickname:
        return "사용 가능한 애칭이에요"
      }
    case .editing(let type):
      switch type {
      case .email:
        return "love@bird.com와 같은 형식으로 입력해 주세요"
      case .nickname:
        return "한글 또는 영어 2-20글자 이내로 입력해 주세요"
      }
    case .error(let type):
      switch type {
      case .email:
        return "love@bird.com와 같은 형식으로 입력해 주세요"
      case .nickname:
        return "잘못된 형식의 애칭이에요"
      }
    case .none:
      return ""
    }
  }

  func update(with email: String) {
    
  }

  static func == (ltf: TextFieldState, rtf: TextFieldState) -> Bool {
    switch (ltf, rtf) {
    case (.correct(let lt), .correct(let rt)), (.error(let lt), .error(let rt)), (.editing(let lt), .editing(let rt)):
      return lt == rt
    case (.none, .none):
      return true
    default:
      return false
    }
  }
}
