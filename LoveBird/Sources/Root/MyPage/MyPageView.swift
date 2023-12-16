//
//  MypageView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/28.
//

import SwiftUI

import ComposableArchitecture
import SwiftUI

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
            if let user = viewStore.user,
                  let userImage = user.profileImageUrl {
              Image(userImage)
            } else {
              HStack(spacing: 60) {
                Spacer()
                
                Image(asset: LoveBirdAsset.icBirdProfileEdit)
                
                Image(asset: LoveBirdAsset.icBirdProfileEdit)
                
                Spacer()
              }
            }
            
            Image(asset: LoveBirdAsset.icBirdGray)
              .changeSize(to: .init(width: 24, height: 24))
              .changeColor(to: Color(asset: LoveBirdAsset.gray04))
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
          .padding(.bottom, 8)
        }
        
        Rectangle()
          .fill(Color(asset: LoveBirdAsset.gray02))
          .frame(height: 20)
          .padding(.top, 30)
        
        VStack(spacing: 0) {
          NavigationLinkStore(
            self.store.scope(state: \.$myPageProfileEdit, action: MyPageAction.myPageProfileEdit)
          ) {
            viewStore.send(.editTapped)
          } destination: { store in
            MyPageProfileEditView(store: store)
          } label: {
            HStack(alignment: .center) {
              Text("회원 정보 수정")
                .font(.pretendard(size: 16))
                .padding(.leading, 16)
              
              Spacer()
            }
            .frame(height: 68)
            .frame(maxWidth: .infinity)
            .bottomBorder()
          }
          
          NavigationLink(destination: MyWebView(urlToLoad: Config.privacyPolicyURL)) {
            HStack(alignment: .center) {
              Text("FAQ")
                .font(.pretendard(size: 16))
                .padding(.leading, 16)
              
              Spacer()
            }
            .frame(height: 68)
            .frame(maxWidth: .infinity)
            .bottomBorder()
          }
          
          NavigationLink(destination: MyWebView(urlToLoad: Config.privacyPolicyURL)) {
            HStack(alignment: .center) {
              Text("개인정보 처리방침")
                .font(.pretendard(size: 16))
                .padding(.leading, 16)
              
              Spacer()
            }
            .frame(height: 68)
            .frame(maxWidth: .infinity)
            .bottomBorder()
          }
          
          HStack(alignment: .center) {
            Text("버전정보")
              .font(.pretendard(size: 16))
              .padding(.leading, 16)
            
            Spacer()
            
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
