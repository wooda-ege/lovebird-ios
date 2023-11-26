//
//  MyPageCore.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/28.
//

import ComposableArchitecture

typealias MyPageState = MyPageCore.State
typealias MyPageAction = MyPageCore.Action

struct MyPageCore: Reducer {

  // MARK: - State

  struct State: Equatable {
    var user: Profile?
  }

  // MARK: - Action

  enum Action: Equatable {
    case editTapped
    case privacyPolicyTapped
    case viewAppear
  }

  // MARK: - Dependency

  @Dependency(\.userData) var userData

  // MARK: - Body

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .viewAppear:
        let user = self.userData.get(key: .user, type: Profile.self)
        if let user { state.user = user }
        return .none

      default:
        return .none
      }
    }
  }
}
