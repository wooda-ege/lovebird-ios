//
//  RootCore.swift
//  wooda
//
//  Created by 황득연 on 2023/05/06.
//

import ComposableArchitecture

struct RootCore: ReducerProtocol {
  enum State: Equatable {
    case onboarding(OnboardingCore.State)
    case mainTab(MainTabCore.State)
    case login(LoginCore.State)

    init() {
      self = .login(LoginCore.State())}
  }
  
  enum Action: Equatable {
    case onboarding(OnboardingCore.Action)
    case mainTab(MainTabCore.Action)
    case login(LoginCore.Action)
  }
  
  @Dependency(\.userData) var userData
  
  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .onboarding(.signUpResponse(.success(let reponse))):
        self.userData.store(key: .userId, value: reponse)
        print("❤️\(reponse.data.dayCount)")
        state = .mainTab(MainTabCore.State())
      case .onboarding(.signUpResponse(.failure(let error))):
        // TODO: error시 정의할 것.
        break
      case .login(.kakaoLoginResponse(.success(let response))):
        let accessToken = response.accessToken
        let refreshToken = response.refreshToken
        
        state = .onboarding(OnboardingCore.State(accessToken: accessToken, refreshToken: refreshToken))
      case .login(.kakaoLoginResponse(.failure(let error))):
        print(error)
      case .login(.appleLoginResponse(.success(let response))):
        let a = response.accessToken
      case .login(.appleLoginResponse(.failure(let error))):
        print(error)
      default:
        break
      }
      return .none
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
