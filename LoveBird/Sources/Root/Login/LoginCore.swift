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
  }
  
  enum Action: Equatable {
    case kakaoLoginTapped(SNSProvider, String)
    case appleLoginTapped(SNSProvider, ASAuthorization)
    case kakaoLoginResponse(TaskResult<LoginResponse>)
    case appleLoginResponse(TaskResult<LoginResponse>)
  }
  
  
  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .kakaoLoginTapped(let provider, let idToken):
        userData.store(key: .idToken, value: idToken)
        userData.store(key: .provider, value: provider.rawValue)
        
        return .run { send in
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
          let tokenString = String(decoding: tokenData!, as: UTF8.self)
          
          userData.store(key: .idToken, value: tokenString)
          userData.store(key: .provider, value: provider)
          
          return .run { send in
            do {
              let appleLoginResponse = try await self.apiClient.request(.login(provider: provider.rawValue, idToken: tokenString)) as LoginResponse
              
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
