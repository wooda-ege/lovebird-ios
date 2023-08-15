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
    @PresentationState var myPageProfileEdit: MyPageProfileEditState?
    var user: Profile?
  }
  
  enum Action: Equatable {
    case myPageProfileEdit(PresentationAction<MyPageProfileEditAction>)
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
        }
      case .editTapped:
        state.myPageProfileEdit = MyPageProfileEditState()
      case .myPageProfileEdit(.presented(.backButtonTapped)):
        state.myPageProfileEdit = nil
        
        // MyPageProfileEdit
      case .myPageProfileEdit(.presented(.editProfileResponse(.success(let profile)))):
        self.userData.store(key: .user, value: profile)
        state.myPageProfileEdit = nil
      default:
        break
      }
      return .none
    }
    .ifLet(\.$myPageProfileEdit, action: /Action.myPageProfileEdit) {
      MyPageProfileEditCore()
    }
  }
}
