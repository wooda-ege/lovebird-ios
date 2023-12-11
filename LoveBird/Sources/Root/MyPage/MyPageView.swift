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
          HStack(alignment: .center, spacing: 0) {
            Spacer()

            Text("D + ")
              .foregroundColor(.black)
              .font(.pretendard(size: 16, weight: .bold))

            Text(String(viewStore.user?.dayCount ?? 0))
              .foregroundColor(Color(asset: LoveBirdAsset.primary))
              .font(.pretendard(size: 16, weight: .bold))

            Spacer()
          }
          .frame(height: 34)
          .padding(.top, 8)

          Rectangle()
            .fill(Color(asset: LoveBirdAsset.gray03))
            .frame(height: 1)
            .padding(.horizontal, 10)

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
              .changeColor(to: Color(asset: LoveBirdAsset.primary))
          }
          .frame(height: 34)
          .padding(.bottom, 8)
        }
        .roundedBackground(cornerRadius: 12, color: Color(asset: LoveBirdAsset.primary))
        .background(.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 2)
        .padding(.top, 30)
        .padding(.horizontal, 16)

        Rectangle()
          .fill(Color(asset: LoveBirdAsset.gray02))
          .frame(height: 20)
          .padding(.top, 30)

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
