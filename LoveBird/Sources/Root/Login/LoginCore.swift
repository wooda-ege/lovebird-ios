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
  let apiClient = APIClient()
  
  struct State: Equatable {
  }
  
  enum Action: Equatable {
    case kakaoLoginTapped(String, String)
    case appleLoginTapped(ASAuthorization)
    case kakaoLoginResponse(TaskResult<KakaoLoginResponse>)
    case appleLoginResponse(TaskResult<AppleLoginResponse>)
  }
  
  
  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .kakaoLoginTapped(let accessToken, let idToken):
        return .task {
          .kakaoLoginResponse(
            await TaskResult {
              try await self.apiClient.request(.kakaoLogin(.init(idToken: idToken, accessToken: accessToken)))
            }
          )
        }
      case .appleLoginTapped(let auth):
        switch auth.credential {
        case let credential as ASAuthorizationAppleIDCredential:
          let tokenData = credential.identityToken
          let tokenString = String(decoding: tokenData!, as: UTF8.self)
          let email = credential.email ?? ""
          let firstName = credential.fullName?.givenName ?? ""
          let lastName = credential.fullName?.familyName ?? ""
          
          return .task {
            .appleLoginResponse(
              await TaskResult {
                try await self.apiClient.request(.appleLogin(.init(idToken: tokenString, user: .init(email: email, name: .init(firstName: firstName, lastName: lastName)))))
              }
            )
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
