//
//  LoginView.swift
//  LoveBird
//
//  Created by 이예은 on 2023/06/29.
//

import ComposableArchitecture
import SwiftUI
import SwiftUIPager
import Foundation
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon
import AuthenticationServices

struct LoginView: View {
  let store: StoreOf<LoginCore>
  
  init(store: StoreOf<LoginCore>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      VStack {
        HStack {
          Image(R.image.img_pinkbird)
            .frame(width: 80, height: 80)
            .padding(.leading, 16)
            .padding(.top, 93)
          Spacer()
        }
        
        VStack {
          HStack {
            Text("함께 쌓는")
              .font(.custom(R.font.pretendardRegular, size: 32))
              .fontWeight(.ultraLight)
            Spacer()
          }
          HStack {
            Text("추억 다이어리")
              .font(.custom(R.font.pretendardRegular, size: 32))
              .fontWeight(.bold)
            Spacer()
          }
          HStack {
            Text(R.string.localizable.login_description)
              .font(.custom(R.font.pretendardRegular, size: 16))
              .fontWeight(.ultraLight)
              .foregroundColor(Color(R.color.gray07))
            Spacer()
          }
          .padding(.top, 3)
        }
        .padding(.top, 10)
        .padding(.leading, 24)
        .padding(.bottom, 212)
        Image(R.image.img_kakaoLogin)
          .resizable()
          .frame(width: 343, height: 60)
          .onTapGesture {
//            if (UserApi.isKakaoTalkLoginAvailable()) {
              UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in // 나중에 톡으로 수정
                if let error = error {
                  print(error)
                }
                else {
                  guard let accessToken = oauthToken?.accessToken,
                         let idToken = oauthToken?.idToken else {
                    return
                  }
                  viewStore.send(.kakaoLoginTapped(accessToken, idToken))
                }
              }
//            }
          }
        
//        Image(R.image.img_appleLogin)
//          .resizable()
//          .frame(width: 343, height: 60)
//          .onTapGesture(perform: showAppleLogin)
        
        SignInWithAppleButton(.continue) { request in
          request.requestedScopes = [.email, .fullName]
        } onCompletion: { result in
          switch result {
          case .success(let auth):
            viewStore.send(.appleLoginTapped(auth))
          case .failure(let error):
            print(error)
          }
        }
        .frame(width: 343, height: 60)
        
        Text("로그인 문의")
          .foregroundColor(Color(R.color.gray09))
          .font(.pretendard(size: 14))
          .padding(.top, 24)
        Spacer()
      }
    }
  }
  
//  private func showAppleLogin() {
//    let request = ASAuthorizationAppleIDProvider().createRequest()
//    request.requestedScopes = [.fullName, .email]
//
//    performSignIn(using: [request])
//  }
//
//  private func performSignIn(using requests: [ASAuthorizationRequest]) {
//    appleSignInDelegates = SignInWithAppleDelegates(window: window) { success in
//      if success {
//
//      } else {
//        // show the user an error
//      }
//    }
//
//    let controller = ASAuthorizationController(authorizationRequests: requests)
//    controller.delegate = appleSignInDelegates
//    controller.presentationContextProvider = appleSignInDelegates
//
//    controller.performRequests()
//
//  }
}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    LoginView(store: Store(initialState: LoginCore.State(), reducer: LoginCore()))
  }
}

