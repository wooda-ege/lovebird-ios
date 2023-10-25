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
  
  struct State: Equatable {
  }
  
  enum Action: Equatable {
    case kakaoLoginTapped(String, String)
    case appleLoginTapped(ASAuthorization)
    case kakaoLoginResponse(TaskResult<LoginResponse>)
    case appleLoginResponse(TaskResult<LoginResponse>)
  }
  
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .kakaoLoginTapped(let accessToken, let idToken):
        return .run { send in
          do {
            let kakaoLoginResponse = try await self.apiClient.request(
              .kakaoLogin(
                kakaoLoginRequest: .init(
                  idToken: idToken,
                  accessToken: accessToken
                )
              )
            ) as LoginResponse
            await send(.kakaoLoginResponse(.success(kakaoLoginResponse)))
          } catch {
            
          }
        }
      case .appleLoginTapped(let auth):
        switch auth.credential {
        case let credential as ASAuthorizationAppleIDCredential:
          let tokenData = credential.identityToken
          let tokenString = String(decoding: tokenData!, as: UTF8.self)
          let email = credential.email ?? ""
          let firstName = credential.fullName?.givenName ?? ""
          let lastName = credential.fullName?.familyName ?? ""
          
          return .run { send in
            do {
              let appleLoginResponse = try await self.apiClient.request(.appleLogin(appleLoginRequest: .init(idToken: tokenString, user: .init(email: email, name: .init(firstName: firstName, lastName: lastName))))) as LoginResponse
              
              await send(.appleLoginResponse(.success(appleLoginResponse)))
            } catch {

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
