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
    
    init() {
                  self = .onboarding(OnboardingCore.State())}
//      self = .mainTab(MainTabCore.State())}
  }
  enum Action: Equatable {
    case onboarding(OnboardingCore.Action)
    case mainTab(MainTabCore.Action)
  }
  
  @Dependency(\.userData) var userData
  
  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .onboarding(.signUpResponse(.success(let reponse))):
        self.userData.store(key: .userId, value: reponse)
        state = .mainTab(MainTabCore.State())
      case .onboarding(.signUpResponse(.failure(let error))):
        // TODO: error시 정의할 것.
        break
      default:
        break
      }
      return .none
    }
    .ifCaseLet(/State.onboarding, action: /Action.onboarding) {
      OnboardingCore()
    }
    .ifCaseLet(/State.mainTab, action: /Action.mainTab) {
      MainTabCore()
    }
  }
  
}
