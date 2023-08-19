//
//  SearchPlaceCore.swift
//  LoveBird
//
//  Created by 이예은 on 2023/05/30.
//

import ComposableArchitecture
import SwiftUI

typealias SearchPlaceState = SearchPlaceCore.State
typealias SearchPlaceAction = SearchPlaceCore.Action

struct SearchPlaceCore: ReducerProtocol {
  struct State: Equatable {
    var placeList: [PlaceInfo] = []
    var searchTerm: String = ""
    var select: String = ""
  }
  
  enum Action: Equatable {
    case textFieldDidEditting(String)
    case selectPlace(String)
    case changePlaceInfo([PlaceInfo])
    case backTapped
    case completeTapped(String)
    case searchPlaceResponse(TaskResult<SearchPlaceResponse>)
  }
  
  @Dependency(\.apiClient) var apiClient
  
  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .textFieldDidEditting(let searchTerm):
        state.searchTerm = searchTerm
        if searchTerm.isEmpty {
          state.placeList.removeAll()
        }
        return .none

      case .changePlaceInfo(let placeInfo):
        state.placeList = placeInfo
        return .none

      default:
        return .none
      }
    }
  }
}



