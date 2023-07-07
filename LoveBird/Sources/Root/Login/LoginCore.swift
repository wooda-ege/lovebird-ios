//
//  LoginCore.swift
//  LoveBird
//
//  Created by 이예은 on 2023/05/30.
//

import ComposableArchitecture
import SwiftUI

struct LoginCore: ReducerProtocol {
  struct State: Equatable {
  }
  
  enum Action: Equatable {
    case kakaoLoginTapped
    case naverLoginTapped
    case appleLoginTapped
    case googleLoginTapped
  }
  
  
  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
//      case .kakaoLoginTapped:
//      case .naverLoginTapped:
//      case .appleLoginTapped:
//      case .googleLoginTapped:
      default:
        break
      }
      
      return .none
    }
  }
}




