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

struct SearchPlaceCore: Reducer {
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

    case delegate(Delegate)
    enum Delegate: Equatable {
      case updatePlace(String)
    }
  }
  
  @Dependency(\.apiClient) var apiClient
  @Dependency(\.dismiss) private var dismiss

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .textFieldDidEditting(searchTerm):
        return .run { send in
          await send(
            .searchPlaceResponse(
              await TaskResult {
                try await apiClient.requestKakaoMap(.searchKakaoMap(query: .init(query: searchTerm)))
              }
            )
          )
        }

      case let .searchPlaceResponse(.success(response)):
        state.placeList = response.place
        return .none

      case let .selectPlace(place), let .completeTapped(place):
        return .send(.delegate(.updatePlace(place)))

      case .backTapped:
        return .run { _ in await dismiss() }

      default:
        return .none
      }
    }
  }
}



