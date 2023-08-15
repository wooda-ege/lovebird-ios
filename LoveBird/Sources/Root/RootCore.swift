//
//  RootCore.swift
//  wooda
//
//  Created by 황득연 on 2023/05/06.
//

import ComposableArchitecture

struct RootCore: Reducer {
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
  
  @Dependency(\.apiClient) var apiClient
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .onboarding(.signUpResponse(.success)):
        state = .mainTab(MainTabCore.State())
      case .onboarding(.signUpResponse(.failure(let error))):
        // TODO: error시 정의할 것.
        break
      case .onboarding(.tryLinkResponse(.success)):
        state = .mainTab(MainTabCore.State())
      case .onboarding(.tryLinkResponse(.failure)):
        return .none
        // 알랏 띄우기
      case .login(.kakaoLoginResponse(.success(let response))):
        let accessToken = response.accessToken
        let refreshToken = response.refreshToken
        let flag = response.flag
        
//        if flag == true {
          state = .onboarding(OnboardingCore.State(accessToken: accessToken, refreshToken: refreshToken ?? ""))
//        } else {
//          state = .mainTab(MainTabCore.State())
//        }
      case .login(.kakaoLoginResponse(.failure(let error))):
        print(error)
      case .login(.appleLoginResponse(.success(let response))):
        let accessToken = response.accessToken
        let refreshToken = response.refreshToken
        
        if response.flag == true {
          state = .onboarding(OnboardingCore.State(accessToken: accessToken, refreshToken: refreshToken ?? ""))
        } else {
          state = .mainTab(MainTabCore.State())
        }
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
