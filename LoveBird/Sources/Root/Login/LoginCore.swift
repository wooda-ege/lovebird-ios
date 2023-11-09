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
  @Dependency(\.apiClient) var apiClient
  @Dependency(\.userData) var userData
  
  struct State: Equatable {}
  
  enum Action: Equatable {
    case login(AuthRequest)
    case loginResponse(TaskResult<LoginResponse>, AuthRequest)
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .login(let auth):
        return .run { send in
          do {
            let loginResponse = try await self.apiClient.request(.login(authRequest: auth)) as LoginResponse
            await send(.loginResponse(.success(loginResponse), auth))
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

public struct TokenInfo: Encodable {
  let provider: SNSProvider
  let idToken: String
}
