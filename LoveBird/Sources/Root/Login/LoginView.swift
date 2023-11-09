//
//  LoginView.swift
//  LoveBird
//
//  Created by 이예은 on 2023/06/29.
//

import ComposableArchitecture
import UIKit
import SwiftUI
import SwiftUIPager
import Foundation
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon
import AuthenticationServices

struct LoginView: View {
  let store: StoreOf<LoginCore>
  let appleSignInDelegates = SignInWithAppleDelegates()
  @Environment(\.window) var window: UIWindow?

  init(store: StoreOf<LoginCore>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack {
        HStack {
          Image(asset: LoveBirdAsset.imgPinkbird)
            .frame(width: 80, height: 80)
            .padding(.leading, 16)
            .padding(.top, 93)
          Spacer()
        }
        
        VStack {
          HStack {
            Text("함께 쌓는")
              .font(.pretendard(size: 32))
              .fontWeight(.ultraLight)
            Spacer()
          }
          HStack {
            Text("추억 다이어리")
              .font(.pretendard(size: 32))
              .fontWeight(.bold)
            Spacer()
          }
          HStack {
            Text(LoveBirdStrings.loginDescription)
              .font(.pretendard(size: 16))
              .fontWeight(.ultraLight)
              .foregroundColor(Color(asset: LoveBirdAsset.gray07))
            Spacer()
          }
          .padding(.top, 3)
        }
        .padding(.top, 10)
        .padding(.leading, 24)
        .padding(.bottom, 212)
        
        Image(asset: LoveBirdAsset.imgKakaoLogin)
          .resizable()
          .frame(height: 60)
          .padding(.horizontal, 16)
          .onTapGesture {
            if (UserApi.isKakaoTalkLoginAvailable()) {
              UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                  print(error)
                } else {
                  guard let idToken = oauthToken?.idToken else {
                    return
                  }
                  
                  UserApi.shared.me {(user, error) in
                    if let error = error {
                      print(error)
                    } else {
                      viewStore.send(
                        .login( .init(provider: .kakao, idToken: idToken))
                      )
                    }
                  }
                }
              }
            } else {
              UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                  print(error)
                } else {
                  guard let idToken = oauthToken?.idToken else {
                    return
                  }
                  
                  UserApi.shared.me {(user, error) in
                    if let error = error {
                      print(error)
                    } else {
                      viewStore.send(
                        .login( .init(provider: .kakao, idToken: idToken))
                      )
                    }
                  }
                }
              }
            }
          }
        
        Image(asset: LoveBirdAsset.imgAppleLogin)
          .resizable()
          .frame(height: 60)
          .padding(.horizontal, 16)
          .onTapGesture(perform: showAppleLogin)
        
        Spacer()
      }
      .onAppear {
        self.performExistingAccountSetupFlows()

        // TODO: Swift Concurrency
        self.appleSignInDelegates.authCallback = {
          viewStore.send(.login($0))
        }
      }
    }
  }
  
  private func showAppleLogin() {
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
    controller.delegate = self.appleSignInDelegates
    controller.presentationContextProvider = self.appleSignInDelegates

    controller.performRequests()
  }
}

#Preview {
  LoginView(
    store: Store(
      initialState: LoginCore.State(),
      reducer: { LoginCore() }
    )
  )
}
