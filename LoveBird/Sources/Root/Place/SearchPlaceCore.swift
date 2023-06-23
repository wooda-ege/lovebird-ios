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
    //        var placeSelection: String = ""
    var placeList: [PlaceInfo] = []
    var searchTerm: String = ""
  }
  
  enum SearchPlaceAction: Equatable {
    case textFieldDidEditting(String)
    case selectPlace
    case changePlaceInfo([PlaceInfo])
    case completeButtonTapped
    case searchPlaceResponse(TaskResult<SearchPlaceResponse>)
  }
  
  @Dependency(\.apiClient) var apiClient
  
  var body: some ReducerProtocol<State, SearchPlaceAction> {
    Reduce { state, action in
      switch action {
      case .textFieldDidEditting(let searchTerm):
        state.searchTerm = searchTerm
        return .none
        
        // 예은: 추후 네트워크 모델 수정되면 변경하기
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
        state.searchTerm = " 장소, 주소를 입력해주세요."
        return .none
      case .changePlaceInfo(let placeInfo):
        state.placeList = placeInfo
        return .none
      default:
        break
      }
      
      return .none
    }
  }
}



