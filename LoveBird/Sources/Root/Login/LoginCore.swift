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
    case kakaoLoginResponse(TaskResult<LoginResponse>, AuthRequest)
    case appleLoginResponse(TaskResult<LoginResponse>, AuthRequest)
  }
  
  
  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .kakaoLoginTapped(let provider, let idToken):
        return .run { send in
          do {
            let kakaoLoginResponse = try await self.apiClient.request(.login(provider: provider.rawValue, idToken: idToken)) as LoginResponse
            
            await send(.kakaoLoginResponse(.success(kakaoLoginResponse), .init(provider: provider, idToken: idToken)))
          } catch {
            await send(.kakaoLoginResponse(.failure(error), .init(provider: provider, idToken: idToken)))
          }
        }
      case .appleLoginTapped(let provider, let auth):
        switch auth.credential {
        case let credential as ASAuthorizationAppleIDCredential:
          let tokenData = credential.identityToken
          let idToken = String(decoding: tokenData!, as: UTF8.self)
          
          return .run { send in
            do {
              let appleLoginResponse = try await self.apiClient.request(.login(provider: provider.rawValue, idToken: idToken)) as LoginResponse
              
              await send(.appleLoginResponse(.success(appleLoginResponse), .init(provider: provider, idToken: idToken)))
            } catch {
              await send(.appleLoginResponse(.failure(error), .init(provider: provider, idToken: idToken)))
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
