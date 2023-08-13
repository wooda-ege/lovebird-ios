//
//  MyPageAnniversaryCore.swift
//  LoveBird
//
//  Created by 황득연 on 2023/08/13.
//

import ComposableArchitecture

typealias MyPageAnniversaryEditState = MyPageAnniversaryEditCore.State
typealias MyPageAnniversaryEditAction = MyPageAnniversaryEditCore.Action

struct MyPageAnniversaryEditCore: ReducerProtocol {

  struct State: Equatable {
  }

  enum Action: Equatable {
  }

  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      default:
        return .none
      }
    }
  }
}
