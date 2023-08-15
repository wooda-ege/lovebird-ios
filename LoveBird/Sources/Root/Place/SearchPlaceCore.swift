//
//  SearchPlaceCore.swift
//  LoveBird
//
//  Created by 이예은 on 2023/05/30.
//

import ComposableArchitecture
import SwiftUI

struct SearchPlaceCore: ReducerProtocol {
  struct State: Equatable {
    var placeList: [PlaceInfo] = []
    var searchTerm: String = ""
  }
  
  enum Action: Equatable {
    case textFieldDidEditting(String)
    case selectPlace
    case changePlaceInfo([PlaceInfo])
    case completeButtonTapped
    case searchPlaceResponse(TaskResult<SearchPlaceResponse>)
  }
  
  @Dependency(\.apiClient) var apiClient
  
  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .textFieldDidEditting(let searchTerm):
        state.searchTerm = searchTerm
          Task {
            do {
              let places = try await apiClient.requestKakaoMap(.searchKakaoMap(searchTerm: searchTerm)) as [PlaceInfo]
//              state.placeList = places
            } catch {
              print("search error!")
            }
          }
      case .completeButtonTapped:
        state.placeList = []
        state.searchTerm = String(resource: R.string.localizable.diary_place_address_title)
      case .changePlaceInfo(let placeInfo):
        state.placeList = placeInfo
      default:
        break
      }
      return .none
    }
  }
}



