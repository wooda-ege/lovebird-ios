//
//  SplashCore.swift
//  LoveBird
//
//  Created by 황득연 on 11/26/23.
//

import Foundation

import ComposableArchitecture

struct SplashCore: Reducer {

  // MARK: - State

  struct State: Equatable {}

  // MARK: - Action

  enum Action: Equatable {
    case viewAppear
  }

  // MARK: - `Reducer` Implementation

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      default:
        return .none
      }
    }
  }
}

typealias SplashState = SplashCore.State
typealias SplashAction = SplashCore.Action
