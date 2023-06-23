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
  }
  
  enum Action: Equatable {
  }
  
  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      default:
        return .none
      }
  struct State: Equatable {
    var searchPlace: SearchPlaceCore.State? = SearchPlaceCore.State()
    var title: String = ""
    var place: String = "장소 선택"
    var isPresented = false
    var text: String = ""
    var image: Image? = nil
  }
  
    enum DiaryCoreAction: Equatable {
        case searchPlace(SearchPlaceCore.Action)
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
      case .searchPlace(.completeButtonTapped(let place)):
          state.place = place
      default:
        break
      }
      return .none
    }
    .ifLet(\.searchPlace, action: /DiaryCore.Action.searchPlace) {
        SearchPlaceCore()
    }
  }
}
