//
//  AppleLoginUtil.swift
//  LoveBird
//
//  Created by 황득연 on 12/31/23.
//

import UIKit
import AuthenticationServices
import Contacts
import SwiftUI
import ComposableArchitecture
import Combine

final class AppleLoginUtil: NSObject {
  var authCallback: ((String) -> Void)?
  let loginSubject = PassthroughSubject<String, Never>()

  func setupCallback() {
    authCallback = { idToken in
      self.loginSubject.send(idToken)
    }
  }

  func showAppleLogin() {
    let request = ASAuthorizationAppleIDProvider().createRequest()

    request.requestedScopes = [.fullName, .email]
    performSignIn(using: [request])
  }

  private func performExistingAccountSetupFlows() {
#if !targetEnvironment(simulator)

    let requests = [
      ASAuthorizationAppleIDProvider().createRequest(),
      ASAuthorizationPasswordProvider().createRequest()
    ]

    performSignIn(using: requests)
#endif
  }

  private func performSignIn(using requests: [ASAuthorizationRequest]) {
    let controller = ASAuthorizationController(authorizationRequests: requests)
    controller.delegate = self
    controller.presentationContextProvider = self

    controller.performRequests()
  }
}

extension AppleLoginUtil: ASAuthorizationControllerDelegate {
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    switch authorization.credential {
    case let appleIdCredential as ASAuthorizationAppleIDCredential:
      if let token = appleIdCredential.identityToken,
         let idToken = String(data: token, encoding: .utf8){
        self.authCallback?(idToken)
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

extension AppleLoginUtil: ASAuthorizationControllerPresentationContextProviding {
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return UIApplication.keyWindow!
  }
}
