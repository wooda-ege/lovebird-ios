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

struct LoginCore: ReducerProtocol {
  @Dependency(\.apiClient) var apiClient
  @Dependency(\.userData) var userData
  
  struct State: Equatable {
    var onboarding = OnboardingCore.State()
  }
  
  enum Action: Equatable {
    case transferInfo(OnboardingCore.Action)
    case kakaoLoginTapped(SNSProvider, String, String)
    case appleLoginTapped(SNSProvider, ASAuthorization)
    case kakaoLoginResponse(TaskResult<LoginResponse>)
    case appleLoginResponse(TaskResult<LoginResponse>)
  }
  
  
  var body: some ReducerProtocol<State, Action> {
    Scope(state: \.onboarding, action: /Action.transferInfo) {
      OnboardingCore()
    }
    
    Reduce { state, action in
      switch action {
      case .kakaoLoginTapped(let provider, let idToken, let email):
        return .run { send in
          await send(.transferInfo(.getInfo(provider, idToken, email)))
          
          do {
            let kakaoLoginResponse = try await self.apiClient.request(.login(provider: provider.rawValue, idToken: idToken)) as LoginResponse
            
            await send(.kakaoLoginResponse(.success(kakaoLoginResponse)))
          } catch {
            await send(.kakaoLoginResponse(.failure(error)))
          }
        }
        
      case .appleLoginTapped(let provider, let auth):
        switch auth.credential {
        case let credential as ASAuthorizationAppleIDCredential:
          let tokenData = credential.identityToken
          let idToken = String(decoding: tokenData!, as: UTF8.self)
          
          guard let email = credential.email else {
            return .none
          }
          
          return .run { send in
//            await send(.transferInfo(provider, idToken, email))
            
            do {
              let appleLoginResponse = try await self.apiClient.request(.login(provider: provider.rawValue, idToken: idToken)) as LoginResponse
              
              await send(.appleLoginResponse(.success(appleLoginResponse)))
            } catch {
              await send(.appleLoginResponse(.failure(error)))

            }
          }
        default:
          break
        }
      default:
        break
      }
      return .none
    }
  }
}
