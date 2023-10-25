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
          .frame(width: 343, height: 60)
          .onTapGesture {
            if (UserApi.isKakaoTalkLoginAvailable()) {
              UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
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
            } else {
              UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
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
            }
          }
        
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
        
        Spacer()
      }
    }
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
