//
//  MyPageEditCore.swift
//  LoveBird
//
//  Created by 황득연 on 2/3/24.
//

import ComposableArchitecture

struct MyPageEditCore: Reducer {

  struct State: Equatable {
  }

  enum Action: Equatable {
    case backTapped
    case profileTapped
    case anniversaryTapped

    //delegate
    case delegate(Delegate)
    enum Delegate: Equatable {
      case goToProfileEdit
      case goToAnniversaryEdit
    }
  }

  @Dependency(\.dismiss) var dismiss

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .backTapped:
        return .run { _ in await self.dismiss() }

      case .profileTapped:
        return .send(.delegate(.goToProfileEdit))

      case .anniversaryTapped:
        return .send(.delegate(.goToAnniversaryEdit))

      default:
        return .none
      }
    }
  }
}

typealias MyPageEditState = MyPageEditCore.State
typealias MyPageEditAction = MyPageEditCore.Action
