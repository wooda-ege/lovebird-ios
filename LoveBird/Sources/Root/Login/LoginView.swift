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
          Text("함께 쌓는 추억 다이어리")
            .font(.custom(R.font.pretendardBold, size: 32))
            .multilineTextAlignment(.leading)
            .frame(width: 180, height: 88)
            .foregroundColor(Color(R.color.gray04))
          Spacer()
        }
        .padding(.top, 60)
        .padding(.leading, 40)
        
        HStack(alignment: .center) {
          Text("러브")
            .foregroundColor(Color(R.color.green100))
          Text("버드")
            .foregroundColor(Color(R.color.secondary))
          Spacer()
        }
        .font(.custom(R.font.gmarketSansBold, size: 31))
        .padding(.top, 96)
        .padding(.bottom, 108)
        .padding(.horizontal, 112)
        
        Image(R.image.img_kakaoLogin)
          .resizable()
          .frame(width: 343, height: 56)
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
        .frame(width: 343, height: 56)
        
        Text("로그인 문의")
          .foregroundColor(Color(R.color.gray09))
          .font(.pretendard(size: 14))
          .padding(.top, 24)
        Spacer()
      }
    }
    
    
  }
  
  func showAppleLogin() {
    let request = ASAuthorizationAppleIDProvider().createRequest()
    request.requestedScopes = [.fullName, .email]
    let controller = ASAuthorizationController(authorizationRequests: [request])
    controller.performRequests()
  }
}
  struct LoginView_Previews: PreviewProvider {
      static var previews: some View {
        LoginView(store: Store(initialState: LoginCore.State(), reducer: LoginCore()))
      }
  }

