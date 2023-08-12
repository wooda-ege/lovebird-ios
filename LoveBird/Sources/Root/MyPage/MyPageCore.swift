//
//  MyPageCore.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/28.
//

import Foundation

import ComposableArchitecture

struct MyPageCore: ReducerProtocol {
  
  struct State: Equatable {
    @PresentationState var MyPageEdit: ScheduleAddState?
    var user: Profile?
  }
  
  enum Action: Equatable {
    case scheduleAdd(PresentationAction<ScheduleAddAction>)
    case viewAppear
  }

  @Dependency(\.userData) var userData

  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .viewAppear:
//        let user = self.userData.get(key: .user) as? Profile
//        if let user {
//          state.user = user
          state.user = .init(nickname: "하이", partnerNickname: "하이", firstDate: "", dayCount: 100, nextAnniversary: .init(kind: .eightYears, anniversaryDate: ""), profileImageUrl: nil, partnerImageUrl: nil)
//        }
      default:
        break
      }
      return .none
    }
  }
}
