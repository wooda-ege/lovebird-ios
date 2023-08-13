//
//  MyPageCore.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/28.
//

import ComposableArchitecture

typealias MyPageState = MyPageCore.State
typealias MyPageAction = MyPageCore.Action

struct MyPageCore: ReducerProtocol {
  
  struct State: Equatable {
    @PresentationState var myPageEdit: MyPageEditState?
    var user: Profile?
  }
  
  enum Action: Equatable {
    case myPageEdit(PresentationAction<MyPageEditAction>)
    case editTapped
    case privacyPolicyTapped
    case viewAppear
  }

  @Dependency(\.userData) var userData

  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .viewAppear:
        let user = self.userData.get(key: .user, type: Profile.self)
        if let user {
          state.user = user
//          state.user = .init(nickname: "하이", partnerNickname: "하이", firstDate: "", dayCount: 100, nextAnniversary: .init(kind: .eightYears, anniversaryDate: ""), profileImageUrl: nil, partnerImageUrl: nil)
        }
      case .editTapped:
        state.myPageEdit = MyPageEditState()
      case .myPageEdit(.presented(.backButtonTapped)):
        state.myPageEdit = nil
      default:
        break
      }
      return .none
    }
    .ifLet(\.$myPageEdit, action: /Action.myPageEdit) {
      MyPageEditCore()
    }
  }
}
