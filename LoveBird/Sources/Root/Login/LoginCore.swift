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

struct LoginCore: Reducer {
  @Dependency(\.apiClient) var apiClient
  @Dependency(\.userData) var userData
  
  struct State: Equatable {
  }
  
  enum Action: Equatable {
    case kakaoLoginTapped(String)
    case appleLoginTapped(ASAuthorization)
    case loginResponse(TaskResult<LoginResponse>, AuthRequest)
  }
  
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .kakaoLoginTapped(let idToken):
        return .run { send in
          do {
            let kakaoLoginResponse = try await self.apiClient.request(.login(info: .init(provider: SNSProvider.kakao, idToken: idToken))) as LoginResponse
            await send(.loginResponse(.success(kakaoLoginResponse), .init(provider: SNSProvider.kakao, idToken: idToken)))
          } catch {
            await send(.loginResponse(.failure(error), .init(provider: SNSProvider.kakao, idToken: idToken)))
          }
        }

      case .appleLoginTapped(let auth):
        switch auth.credential {
        case let credential as ASAuthorizationAppleIDCredential:
          let tokenData = credential.identityToken
          let idToken = String(decoding: tokenData!, as: UTF8.self)
          
          return .run { send in
            do {
              let appleLoginResponse = try await self.apiClient.request(.login(info: TokenInfo.init(provider: SNSProvider.apple, idToken: idToken))) as LoginResponse
              await send(.loginResponse(.success(appleLoginResponse), .init(provider: SNSProvider.apple, idToken: idToken)))
            } catch {
              await send(.loginResponse(.failure(error), .init(provider: SNSProvider.apple, idToken: idToken)))
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

public struct TokenInfo: Encodable {
  let provider: SNSProvider
  let idToken: String
}
