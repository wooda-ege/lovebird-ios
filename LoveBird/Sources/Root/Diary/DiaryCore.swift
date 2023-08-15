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
    var place: String = String(resource: R.string.localizable.diary_select_place)
    var isPresented = false
    var text: String = ""
    var image: Image? = nil
  }
  
  enum Action: Equatable {
    case titleLabelTapped(String)
    case selectPlaceLabelTapped
    case textDidEditting(String)
    case changeTextEmpty
    case completeButtonTapped
  }
  
  @Dependency(\.apiClient) var apiClient
  
  var body: some ReducerProtocol<State, Action> {
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
        break
//        return .run { send in
//          try await apiClient.request(.registerDiary)
//
//        }
      default:
        break
      }
      return .none
    }
  }
}
