//
//  KakaoLoginUtil.swift
//  LoveBird
//
//  Created by 황득연 on 12/31/23.
//

import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon

struct KakaoLoginUtil {
  func login() async throws -> String {
    return try await withCheckedThrowingContinuation { continuation in
      if UserApi.isKakaoTalkLoginAvailable() {
        UserApi.shared.loginWithKakaoTalk { oauthToken, error in
          if let error = error {
            continuation.resume(throwing: error)
          } else if let idToken = oauthToken?.idToken {
            continuation.resume(returning: idToken)
          } else {
            continuation.resume(throwing: KakaoError.unknown)
          }
        }
      } else {
        UserApi.shared.loginWithKakaoAccount { oauthToken, error in
          if let error = error {
            continuation.resume(throwing: error)
          } else if let idToken = oauthToken?.idToken {
            continuation.resume(returning: idToken)
          } else {
            continuation.resume(throwing: KakaoError.unknown)
          }
        }
      }
    }
  }

  //          UserApi.shared.me {(user, error) in
  //            if let error = error {
  //              print(error)
  //            } else {
  //              viewStore.send(
  //                .login( .init(provider: .kakao, idToken: idToken))
  //              )
  //            }
  //          }
}

enum KakaoError: Error {
  case unknown
}
