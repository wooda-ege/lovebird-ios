//
//  MypageView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/28.
//

import SwiftUI

import ComposableArchitecture
import SwiftUI
import Kingfisher

struct MyPageView: View {
  let store: StoreOf<MyPageCore>
  
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack {
        Text("마이페이지")
          .font(.pretendard(size: 18, weight: .bold))
          .frame(height: 44)
        
        VStack(spacing: 5) {
          ZStack(alignment: .center) {
            HStack(spacing: 20) {
              Spacer()

              if let urlString = viewStore.user?.profileImageUrl {
                KFImage(URL(string: urlString))
                  .frame(size: 80)
              } else {
                Circle()
                  .fill(Color(asset: LoveBirdAsset.gray02))
                  .frame(width: 80, height: 80)
                  .overlay(Image(asset: LoveBirdAsset.icBirdEdit), alignment: .center)
                  .overlay(
                    Circle()
                      .stroke(Color(asset: LoveBirdAsset.gray05), lineWidth: 1)
                  )
              }

              Image(asset: LoveBirdAsset.icBirdGray)
                .changeSize(to: .init(width: 24, height: 24))
                .changeColor(to: Color(asset: LoveBirdAsset.gray04))

              if let urlString = viewStore.user?.partnerImageUrl {
                KFImage(URL(string: urlString))
                  .frame(size: 80)
              } else {
                Circle()
                  .fill(Color(asset: LoveBirdAsset.gray02))
                  .frame(width: 80, height: 80)
                  .overlay(Image(asset: LoveBirdAsset.icBirdEdit), alignment: .center)
                  .overlay(
                    Circle()
                      .stroke(Color(asset: LoveBirdAsset.gray05), lineWidth: 1)
                  )
              }

              Spacer()
            }
          }

          HStack(alignment: .center, spacing: 0) {
            Spacer()
            
            Text("사랑한 지 ")
              .foregroundColor(.black)
              .font(.pretendard(size: 16, weight: .bold))
            
            Text(String(viewStore.user?.dayCount ?? 0))
              .foregroundColor(Color(asset: LoveBirdAsset.primary))
              .font(.pretendard(size: 16, weight: .bold))
            
            Text(" 일 째")
              .foregroundColor(.black)
              .font(.pretendard(size: 16, weight: .bold))
            
            Spacer()
          }
          .frame(height: 34)
          .padding(.top, 8)
          
          ZStack(alignment: .center) {
            HStack(spacing: 34) {
              Text(viewStore.user?.nickname ?? "")
                .font(.pretendard(size: 14))
                .frame(maxWidth: .infinity, alignment: .trailing)
              
              Text(viewStore.user?.partnerNickname ?? "")
                .font(.pretendard(size: 14))
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Image(asset: LoveBirdAsset.icBird)
              .changeSize(to: .init(width: 24, height: 24))
              .changeColor(to: Color(asset: LoveBirdAsset.gray04))
          }
          .frame(height: 34)
        }
        
        Rectangle()
          .fill(Color(asset: LoveBirdAsset.gray02))
          .frame(height: 20)
          .padding(.top, 20)

        VStack(spacing: 0) {
          Button { viewStore.send(.editTapped) } label: {
            MyPageItemView(title: "프로필 수정")
          }

          NavigationLink(destination: MyWebView(urlToLoad: Config.privacyPolicyURL)) {
            MyPageItemView(title: "개인정보 처리방침")
          }

          MyPageItemView(title: "버전정보") {
            Text(Bundle.main.version)
              .font(.pretendard(size: 16))
              .padding(.trailing, 16)
          }
        }
        .padding(.top, 10)
        .padding(.horizontal, 16)
        
        Spacer()
      }
      .foregroundColor(.black)
      .onAppear {
        viewStore.send(.viewAppear)
      }
    }
  }
}

#Preview {
  MyPageView(
    store: .init(
      initialState: MyPageState(user: Profile.dummy),
      reducer: { MyPageCore() }
    )
  )
}
