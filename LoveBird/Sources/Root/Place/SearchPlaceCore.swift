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
    var select: String = ""
  }
  
  enum Action: Equatable {
    case textFieldDidEditting(String)
    case selectPlace(String)
    case changePlaceInfo([PlaceInfo])
    case completeButtonTapped
    case viewDidLoad
    case searchPlaceResponse(TaskResult<SearchPlaceResponse>)
  }
  
  @Dependency(\.apiClient) var apiClient
  
  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .textFieldDidEditting(let searchTerm):
        state.searchTerm = searchTerm
      case .completeButtonTapped:
        state.placeList = []
      case .changePlaceInfo(let placeInfo):
        state.placeList = placeInfo
      case .selectPlace(let place):
        state.select = place        // diaryview의 place state로 보내줘야함 
      case .viewDidLoad:
        state.placeList = []
//        state.searchTerm = String(resource: R.string.localizable.diary_place_address_title)
      default:
        break
      }
      return .none
    }
  }
}



