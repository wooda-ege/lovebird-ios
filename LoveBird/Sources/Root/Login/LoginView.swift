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
      .font(.custom(R.font.gmarketSansBold, size: 38))
      .padding(.top, 96)
      .padding(.bottom, 108)
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
        .padding(.top, 24)
      Spacer()
    }
  }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
