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
        
        // 예은:: 추후 네트워크 모델 수정되면 변경하기
        //        return .task { [searchTerm = state.searchTerm] in
        //          .searchPlaceResponse(
        //            await TaskResult {
        //              try await
        //              self.apiClient.request(.searchPlace(.init(placeName: searchTerm)))
        //            }
        //          )
        //        }
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



