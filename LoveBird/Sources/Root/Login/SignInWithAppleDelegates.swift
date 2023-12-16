//
//  SignInWithAppleDelegates.swift
//  LoveBird
//
//  Created by 이예은 on 2023/10/16.
//

import UIKit
import AuthenticationServices
import Contacts
import SwiftUI
import ComposableArchitecture

final class SignInWithAppleDelegates: NSObject {
  var authCallback: ((Authenticate) -> Void)?
}

extension SignInWithAppleDelegates: ASAuthorizationControllerDelegate {
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    switch authorization.credential {
    case let appleIdCredential as ASAuthorizationAppleIDCredential:
      if let token = appleIdCredential.identityToken,
         let encodedToken = String(data: token, encoding: .utf8){
        let auth = Authenticate(provider: .apple, idToken: encodedToken)
        self.authCallback?(auth)
      }
      break

    default:
      break
    }
  }
  
  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // 에러 처리
  }
}

extension SignInWithAppleDelegates: ASAuthorizationControllerPresentationContextProviding {
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return UIApplication.keyWindow!
  }
}
