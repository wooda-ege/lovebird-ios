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
          .frame(height: 56)
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
                      viewStore.send(.kakaoLoginTapped(Provider.KAKAO.rawValue, idToken))
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
                      viewStore.send(.kakaoLoginTapped(Provider.KAKAO.rawValue, idToken))
                    }
                  }
                }
              }
            }
          }
        
        SignInWithAppleButton(.continue) { request in
          request.requestedScopes = [.email, .fullName]
        } onCompletion: { result in
          switch result {
          case .success(let auth):
            viewStore.send(.appleLoginTapped(Provider.APPLE.rawValue, auth))
          case .failure(let error):
            print(error)
          }
        }
        .padding(.horizontal, 16)
        .frame(height: 56)
        
        Spacer()
      }
    }
  }
}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    LoginView(store: Store(initialState: LoginCore.State(), reducer: LoginCore()))
  }
}

