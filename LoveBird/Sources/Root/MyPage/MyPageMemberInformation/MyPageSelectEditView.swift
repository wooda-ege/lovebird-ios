//
//  MyPageSelectEditView.swift
//  LoveBird
//
//  Created by 이예은 on 11/12/23.
//

import SwiftUI

struct MyPageSelectEditView: View {
  var body: some View {
    VStack {
      CommonToolBar(title: "회원정보 수정") {
      } content: {
        Button {} label: {}
      }
      
      // TODO:: 예은 화면 전환 구현하기
      NavigationLink(destination: MyWebView(urlToLoad: Config.privacyPolicyURL)) {
        HStack(alignment: .center) {
          Text("프로필 정보")
            .font(.pretendard(size: 16))
            .padding(.leading, 16)
            .foregroundColor(.black)
          Spacer()
          
          Image(asset: LoveBirdAsset.icArrowRight)
        }
        .frame(height: 68)
        .frame(maxWidth: .infinity)
        .bottomBorder()
        .padding(.horizontal, 16)
      }
      
      NavigationLink(destination: MyWebView(urlToLoad: Config.privacyPolicyURL)) {
        HStack(alignment: .center) {
          Text("기념일 정보")
            .foregroundStyle(.black)
            .font(.pretendard(size: 16))
            .padding(.leading, 16)
          
          Spacer()
          
          Image(asset: LoveBirdAsset.icArrowRight)
        }
        .frame(height: 68)
        .frame(maxWidth: .infinity)
        .bottomBorder()
        .padding(.horizontal, 16)
      }
    }
    
    Spacer()
  }
}

#Preview {
    MyPageSelectEditView()
}
