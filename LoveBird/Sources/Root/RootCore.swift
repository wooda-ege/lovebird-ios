//
//  RootCore.swift
//  wooda
//
//  Created by 황득연 on 2023/05/06.
//

import UIKit
import ComposableArchitecture
import AVFoundation
import Photos

// MARK: - Typealias

typealias RootAction = RootCore.Action
typealias RootState = RootCore.State

struct RootCore: Reducer {

  // MARK: - Constants

  enum Constants {
    static let delayOfSplash: Int = 1
  }

  // MARK: - State
  
  enum State: Equatable {
    case splash(SplashState)
    case onboarding(OnboardingState)
    case mainTab(MainTabState)
    case login(LoginState)
    case coupleLink(CoupleLinkState)

    init() {
      self = .splash(.init())
    }
  }

  // MARK: - Action
  
  enum Action: Equatable {
    case splash(SplashAction)
    case onboarding(OnboardingAction)
    case mainTab(MainTabAction)
    case login(LoginAction)
    case coupleLink(CoupleLinkAction)
    case updateRootState(State)
    case viewAppear
  }
  
  // MARK: - Dependency
  
  @Dependency(\.lovebirdApi) var lovebirdApi
  @Dependency(\.userData) var userData
  @Dependency(\.continuousClock) var continuousClock

  // MARK: - Body

  var body: some Reducer<State, Action> {
    Reduce(core)
      .ifCaseLet(/State.splash, action: /Action.splash, then: SplashCore.init)
      .ifCaseLet(/State.onboarding, action: /Action.onboarding, then: OnboardingCore.init)
      .ifCaseLet(/State.mainTab, action: /Action.mainTab, then: MainTabCore.init)
      .ifCaseLet(/State.login, action: /Action.login, then: LoginCore.init)
      .ifCaseLet(/State.coupleLink, action: /Action.coupleLink, then: CoupleLinkCore.init)
  }

  func core(state: inout State, action: Action) -> Effect<Action> {
    switch action {

    // MARK: - Splash

    case .splash(.viewAppear):
      return .run { send in
        try await continuousClock.sleep(for: .seconds(Constants.delayOfSplash))
        let user = userData.get(key: .user, type: Profile.self)
        let rootState = switchState(with: user)
        await send(.updateRootState(rootState), animation: .default)
      }

    // MARK: - Login

    case .login(.loginResponse(.success(let response), _)):
      userData.store(key: .accessToken, value: response.accessToken)
      userData.store(key: .refreshToken, value: response.refreshToken)

      if response.linkedFlag == true {
        return .send(.updateRootState(.mainTab(.init())))
      } else {
        return .send(.updateRootState(.coupleLink(.init())))
      }

    case .login(.loginResponse(.failure, let auth)):
//        if 특정 약속된 로그인 실패 인경우 { ... } 현석이랑 약속해서 처리하면 좋음
//        else 그외 네트워크 오류 등등 일 경우 { ... }
      return .send(.updateRootState(.onboarding(.init(auth: auth))))

    // MARK: - Onboarding

    case .onboarding(.signUpResponse(.success(let response))):
      userData.store(key: .accessToken, value: response.accessToken)
      userData.store(key: .refreshToken, value: response.refreshToken)

      return .run { send in
        do {
          let profile = try await lovebirdApi.fetchProfile()
          userData.store(key: .user, value: profile)

          await send(.updateRootState(.coupleLink(.init())))
        } catch {
          print("FetchProfile Error: \(error)")
        }
      }

    // MARK: - CoupleLink

    case .coupleLink(.successToLink):
      return .send(.updateRootState(.mainTab(.init())))

    // MARK: - My Page

    case let .mainTab(.path(.element(id: _, action: .myPageProfileEdit(.delegate(action))))):
      switch action {
      case .withdrawal:
        userData.removeAll()
        return .send(.updateRootState(.login(.init())))
      }

    // MARK: - Etc

    case .updateRootState(let rootState):
      state = rootState
      return .none

    default:
      return .none
    }
  }

  // MARK: - Private Methods
  
  private func switchState(with profile: Profile?) -> State {
    guard let profile else { return .login(LoginCore.State()) }

    if profile.partnerId.isNil {
      return .coupleLink(CoupleLinkCore.State())
    } else {
      return .mainTab(MainTabCore.State())
    }
  }
}

