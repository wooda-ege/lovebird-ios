//
//  MyPageEditCore.swift
//  LoveBird
//
//  Created by 황득연 on 2023/08/12.
//

import ComposableArchitecture

typealias MyPageEditState = MyPageEditCore.State
typealias MyPageEditAction = MyPageEditCore.Action

struct MyPageEditCore: ReducerProtocol {

  struct State: Equatable {
    @PresentationState var myPageProfileEdit: MyPageProfileEditState?
    @PresentationState var myPageAnniversaryEdit: MyPageAnniversaryEditState?
  }

  enum Action: Equatable {
    case myPageProfileEdit(PresentationAction<MyPageProfileEditAction>)
    case myPageAnniversaryEdit(PresentationAction<MyPageAnniversaryEditAction>)
    case profileEditTapped
    case anniversaryEditTapped
    case backButtonTapped
  }

  @Dependency(\.userData) var userData

  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .profileEditTapped:
        state.myPageProfileEdit = MyPageProfileEditState()
      case .anniversaryEditTapped:
        state.myPageAnniversaryEdit = MyPageAnniversaryEditState()

        // MyPageProfileEdit
      case .myPageProfileEdit(.presented(.editProfileResponse(.success(let profile)))):
        self.userData.store(key: .user, value: profile)
        state.myPageProfileEdit = nil
      case .myPageProfileEdit(.presented(.backButtonTapped)):
        state.myPageProfileEdit = nil
      default:
        break
      }
      return .none
    }
    .ifLet(\.$myPageProfileEdit, action: /MyPageEditAction.myPageProfileEdit) {
      MyPageProfileEditCore()
    }
    .ifLet(\.$myPageAnniversaryEdit, action: /MyPageEditAction.myPageAnniversaryEdit) {
      MyPageAnniversaryEditCore()
    }
  }
}
