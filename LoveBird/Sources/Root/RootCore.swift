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

      case .login(.kakaoLoginResponse(.success(let response), _)), .login(.appleLoginResponse(.success(let response), _)):
        userData.store(key: .accessToken, value: response.accessToken)
        userData.store(key: .refreshToken, value: response.refreshToken)
        
        if response.linkedFlag == true {
          return .send(.updateRootState(.mainTab(MainTabCore.State())))
        } else {
          return .send(.updateRootState(.coupleLink(CoupleLinkCore.State())))
        }
        
      case .login(.kakaoLoginResponse(.failure(let error), let info)), .login(.appleLoginResponse(.failure(let error), let info)):
        print(error)
        
        return .send(.updateRootState(.onboarding(OnboardingCore.State(provider: .kakao, idToken: info.idToken))))
        
      // MARK: - Onboarding
        
      case .onboarding(.registerProfileResponse(.success(let response))):
        userData.store(key: .accessToken, value: response.accessToken)
        userData.store(key: .refreshToken, value: response.refreshToken)
        
        return .run { send in
          do {
            let profile = try await apiClient.request(.fetchProfile) as Profile
            userData.store(key: .user, value: profile)
            
            await send(.updateRootState(.coupleLink(CoupleLinkCore.State())))
          } catch {
            await send(.updateRootState(.coupleLink(CoupleLinkCore.State())))
            
          }
        }

        // MARK: - CoupleLink
        
      case .coupleLink(.tryLinkResponse(.success(let response))):
        if response.isSuccess {
          return .send(.updateRootState(.mainTab(MainTabCore.State())))
        } else {
          print("link 실패")
          return .none
        }

      // MARK: - My Page
        
      case .mainTab(.myPage(.myPageProfileEdit(.presented(.withdrawalResponse(.success))))):
        self.userData.remove(key: .user)
        self.userData.remove(key: .accessToken)
        self.userData.remove(key: .refreshToken)
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
