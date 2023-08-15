//
//  ImagePickerCore.swift
//  LoveBird
//
//  Created by 황득연 on 2023/08/14.
//

import ComposableArchitecture


struct ImagePickerCore: ReducerProtocol {

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
