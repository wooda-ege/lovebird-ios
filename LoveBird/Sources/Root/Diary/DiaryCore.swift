//
//  DiaryCore.swift
//  JsonPractice
//
//  Created by 이예은 on 2023/05/30.
//

import ComposableArchitecture
import SwiftUI

struct DiaryCore: ReducerProtocol {
  struct State: Equatable {
    var title: String = ""
    var place: String = "장소 선택"
    var isPresented = false
    var text: String = ""
      var image: Image? = nil
  }
  
    enum DiaryCoreAction: Equatable {
        case titleLabelTapped(String)
        case selectPlaceLabelTapped
        case textDidEditting(String)
        case changeTextEmpty
        case completeButtonTapped
    }
  
  var body: some ReducerProtocol<State, DiaryCoreAction> {
    Reduce<State, Action> { state, action in
      switch action {
      case .titleLabelTapped(let title):
        state.title = title
        return .none
      case .selectPlaceLabelTapped:
        return .none
      case .textDidEditting(let text):
        state.text = text
        return .none
      case .changeTextEmpty:
        state.text = ""
      case .completeButtonTapped:
          state.title = ""
          state.text = ""
      default:
        break
      }
      return .none
    }
  }
}
