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

class SignInWithAppleDelegates: NSObject {
  private weak var window: UIWindow!
  let store: StoreOf<LoginCore>
  
  init(window: UIWindow?, store: StoreOf<LoginCore>) {
    self.window = window
    self.store = store
  }
}

extension SignInWithAppleDelegates: ASAuthorizationControllerDelegate {
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    switch authorization.credential {
    case let appleIdCredential as ASAuthorizationAppleIDCredential:
      if let _ = appleIdCredential.email, let _ = appleIdCredential.fullName {
        store.send(.appleLoginTapped(authorization))
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
    return self.window
  }
}
