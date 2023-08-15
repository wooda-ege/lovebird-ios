//
//  RootCore.swift
//  wooda
//
//  Created by 황득연 on 2023/05/06.
//

import UIKit
import ComposableArchitecture

// MARK: - Typealias

typealias RootAction = RootCore.Action
typealias RootState = RootCore.State

struct RootCore: Reducer {

  // MARK: - Constants

  enum Constants {
    static let delayOfSplash: UInt64 = 1 * 1_000_000_000
  }

  // MARK: - State
  
  enum State: Equatable {
    case splash
    case onboarding(OnboardingCore.State)
    case mainTab(MainTabCore.State)
    case login(LoginCore.State)
    
    init() {
      self = .splash
    }
  }

  // MARK: - Action
  
  enum Action: Equatable {
    case onboarding(OnboardingCore.Action)
    case mainTab(MainTabCore.Action)
    case login(LoginCore.Action)
    case updateRootState(State)
    case viewAppear
  }

  // MARK: - Dependency

  @Dependency(\.apiClient) var apiClient
  @Dependency(\.userData) var userData

  // MARK: - Body
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {

      // MARK: - Life Cycle

      case .viewAppear:
        return .run { send in
          try await Task.sleep(nanoseconds: Constants.delayOfSplash)

          let user = self.userData.get(key: .user, type: Profile.self)
          var rootState: State
          if user == nil {
//            rootState = .login(LoginCore.State())
            rootState = .mainTab(MainTabCore.State())
          } else {
            rootState = .mainTab(MainTabCore.State())
          }
          await send(.updateRootState(rootState), animation: .default)
        }

      // MARK: - Onboarding

      case .onboarding(.signUpResponse(.success)):
        return .send(.updateRootState(.mainTab(MainTabCore.State())))

      case .onboarding(.tryLinkResponse(.success)):
        return .send(.updateRootState(.mainTab(MainTabCore.State())))

      case .onboarding(.tryLinkResponse(.failure)):
        return .none

      // MARK: - Login

        // 알랏 띄우기
      case .login(.kakaoLoginResponse(.success(let response))):
        let accessToken = response.accessToken
        let refreshToken = response.refreshToken
        let flag = response.flag
        if flag == true {
          state = .onboarding(OnboardingCore.State(accessToken: accessToken, refreshToken: refreshToken ?? ""))
        } else {
          state = .mainTab(MainTabCore.State())
        }
        return .none

      case .login(.kakaoLoginResponse(.failure(let error))):
        print(error)
        return .none

      case .login(.appleLoginResponse(.success(let response))):
        let accessToken = response.accessToken
        let refreshToken = response.refreshToken
        
        if response.flag == true {
          state = .onboarding(OnboardingCore.State(accessToken: accessToken, refreshToken: refreshToken ?? ""))
        } else {
          state = .mainTab(MainTabCore.State())
        }
        return .none

      case .login(.appleLoginResponse(.failure(let error))):
        print(error)
        return .none

      // MARK: - Etc

      case .updateRootState(let rootState):
        state = rootState
        return .none

      default:
        return .none
      }
    }
    .ifCaseLet(/State.onboarding, action: /Action.onboarding) {
      OnboardingCore()
    }
    .ifCaseLet(/State.login, action: /Action.login) {
      LoginCore()
    }
    .ifCaseLet(/State.mainTab, action: /Action.mainTab) {
      MainTabCore()
    }
  }
}
