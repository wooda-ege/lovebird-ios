//
//  LoginCore.swift
//  LoveBird
//
//  Created by 이예은 on 2023/05/30.
//

import ComposableArchitecture
import SwiftUIPager
import SwiftUI
import AuthenticationServices
import KakaoSDKAuth

typealias LoginState = LoginCore.State
typealias LoginAction = LoginCore.Action

struct LoginCore: Reducer {
  struct State: Equatable {}
  
  enum Action: Equatable {
    case login(Authenticate)
    case loginResponse(TaskResult<Token>, Authenticate)
  }

  @Dependency(\.lovebirdApi) var lovebirdApi
  @Dependency(\.userData) var userData

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .login(let auth):
        return .run { send in
          do {
            let token = try await lovebirdApi.authenticate(auth: auth)
            await send(.loginResponse(.success(token), auth))
          } catch {
            await send(.loginResponse(.failure(error), auth))
          }
        }

      default:
        break
      }
      return .none
    }
  }
}
