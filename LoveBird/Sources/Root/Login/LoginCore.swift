//
//  LoginCore.swift
//  LoveBird
//
//  Created by 이예은 on 2023/05/30.
//

import ComposableArchitecture
import SwiftUI
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon
import AuthenticationServices

typealias LoginState = LoginCore.State
typealias LoginAction = LoginCore.Action

struct LoginCore: Reducer {
  struct State: Equatable {}
  
  enum Action: Equatable {
    case login(Authenticate)
    case loginResponse(TaskResult<Token>, Authenticate)
    case kakaoTapped
    case appleTapped
    case viewAppear
  }

  @Dependency(\.lovebirdApi) var lovebirdApi
  @Dependency(\.userData) var userData
  @Dependency(\.kakaoLoginUtil) var kakaoLoginUtil
  @Dependency(\.appleLoginUtil) var appleLoginUtil

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .kakaoTapped:
        return .run { send in
          let idToken = try await kakaoLoginUtil.login()
          await send(.login(.init(provider: .kakao, idToken: idToken)))
        }

      case .appleTapped:
        appleLoginUtil.showAppleLogin()
        return .none

      case .login(let auth):
        return .run { send in
          do {
            let token = try await lovebirdApi.authenticate(auth: auth)
            await send(.loginResponse(.success(token), auth))
          } catch {
            await send(.loginResponse(.failure(error), auth))
          }
        }

      case .viewAppear:
        appleLoginUtil.setupCallback()
        return .publisher {
          appleLoginUtil.loginSubject
            .map { Action.login(.init(provider: .apple, idToken: $0)) }
        }

      default:
        return .none
      }
    }
  }
}
