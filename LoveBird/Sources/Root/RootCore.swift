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
    case coupleLink(CoupleLinkCore.State)
    case diary(DiaryCore.State)
    
    init() {
      self = .splash
    }
  }

  // MARK: - Action
  
  enum Action: Equatable {
    case onboarding(OnboardingCore.Action)
    case mainTab(MainTabCore.Action)
    case login(LoginCore.Action)
    case coupleLink(CoupleLinkCore.Action)
    case updateRootState(State)
    case diary(DiaryCore.Action)
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
            rootState = .login(LoginCore.State())
          } else if user?.partnerId == nil {
            rootState = .coupleLink(CoupleLinkCore.State())
          } else {
            rootState = .mainTab(MainTabCore.State())
          }
          await send(.updateRootState(rootState), animation: .default)
        }
        
      // MARK: - Login

      case .login(.kakaoLoginResponse(.success(let response))), .login(.appleLoginResponse(.success(let response))):
        return .run { send in
          userData.store(key: .accessToken, value: response.accessToken)
          userData.store(key: .refreshToken, value: response.refreshToken)

          if response.flag == true { // 신규
            await send(.updateRootState(.onboarding(OnboardingCore.State())))
          } else { // 기존
            do {
              let profile = try await apiClient.request(.fetchProfile) as Profile
              if profile.partnerId == nil {
                await send(.updateRootState(.coupleLink(CoupleLinkCore.State())))
              } else {
                await send(.updateRootState(.mainTab(MainTabCore.State())))
              }
            }
          }
        }

      case .login(.kakaoLoginResponse(.failure(let error))), .login(.appleLoginResponse(.failure(let error))):
        print(error)
        return .none

      case .login(.appleLoginResponse(.success(let response))):
        return .run { send in
          userData.store(key: .accessToken, value: response.accessToken)
          userData.store(key: .refreshToken, value: response.refreshToken)
          
          if response.flag == true { // 신규
            await send(.updateRootState(.onboarding(OnboardingCore.State())))
          } else { // 기존
            do {
              let profile = try await apiClient.request(.fetchProfile(authorization: response.accessToken, refresh: response.refreshToken ?? "")) as Profile
              if profile.partnerId == nil {
                await send(.updateRootState(.coupleLink(CoupleLinkCore.State())))
              } else {
                await send(.updateRootState(.mainTab(MainTabCore.State())))
              }
            }
          }
        }
      case .login(.appleLoginResponse(.failure(let error))):
        print(error)
        return .none
        
      // MARK: - Onboarding
        
      case .onboarding(.registerProfileResponse(.success)):
        return .send(.updateRootState(.coupleLink(CoupleLinkCore.State())))
        
      case .onboarding(.tryLinkResponse(.success)):
        return .send(.updateRootState(.mainTab(MainTabCore.State())))
        
      case .onboarding(.tryLinkResponse(.failure)):
        return .none
        
      // MARK: - CoupleLink
        
      case .coupleLink(.tryLinkResponse(.success(let response))):
        if response.isSuccess {
          return .send(.updateRootState(.mainTab(MainTabCore.State())))
        } else {
          print("link 실패")
          return .none
        }

      // MARK: - My Page
      case .mainTab(.myPage(.myPageProfileEdit(.presented(.deleteProfileResponse(.success))))):
        state = .login(LoginCore.State())
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
    .ifCaseLet(/State.coupleLink, action: /Action.coupleLink) {
      CoupleLinkCore()
    }
    .ifCaseLet(/State.diary, action: /Action.diary) {
      DiaryCore()
    }
  }
}
