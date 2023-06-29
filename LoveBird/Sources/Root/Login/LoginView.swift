//
//  LoginView.swift
//  LoveBird
//
//  Created by 이예은 on 2023/06/29.
//

import SwiftUI

struct LoginView: View {
  var body: some View {
    VStack {
      HStack {
        Text("함께 쌓는 추억 다이어리")
          .multilineTextAlignment(.leading)
          .frame(width: 180, height: 88)
        Spacer()
      }
      .font(.pretendard(size: 32))
      .foregroundColor(Color(R.color.gray05))
      .padding(.top, 60)
      .padding(.leading, 40)

      HStack(alignment: .center) {
        Text("러브")
          .font(.pretendard(size: 40))
          .foregroundColor(Color(R.color.green100))
        Text("버드")
          .font(.pretendard(size: 40))
          .foregroundColor(Color(R.color.secondary))
        
        Spacer()
      }
      .padding(.top, 95)
      .padding(.bottom, 100)
      .padding(.horizontal, 112)
      
      Image(R.image.img_kakaoLogin)
        .resizable()
        .frame(width: 343, height: 56)
      Image(R.image.img_naverLogin)
        .resizable()
        .frame(width: 343, height: 56)
      Image(R.image.img_appleLogin)
        .resizable()
        .frame(width: 343, height: 56)
      Image(R.image.img_googleLogin)
        .resizable()
        .frame(width: 343, height: 56)
      
      Text("로그인 문의")
        .foregroundColor(Color(R.color.gray09))
        .font(.pretendard(size: 14))
        .padding(.top, 17)
      Spacer()
    }
  }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
