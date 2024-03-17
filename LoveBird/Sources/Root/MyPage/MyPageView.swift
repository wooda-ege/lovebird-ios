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
  @StateObject private var keyboard = KeyboardResponder()

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      ZStack {
        VStack {
          toolbar
          coupleStatusView

          Rectangle()
            .fill(Color(asset: LoveBirdAsset.gray02))
            .frame(height: 20)
            .padding(.top, 20)
            .padding(.bottom, 10)

          settingsView

          Spacer()
        }
        .foregroundColor(.black)

        coupleLinkBottomSheetView
      }
      .onChange(of: viewStore.isCoupleLinkVisible) {
        if $0.not { hideKeyboard() }
      }
      .onAppear {
        viewStore.send(.viewAppear)
      }
    }
  }
}

private extension MyPageView {
  var toolbar: some View {
    CommonToolBar<EmptyView>(title: "마이페이지")
  }

  var coupleStatusView: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 5) {
        ZStack(alignment: .center) {
          CenterAlignedHStack(spacing: 20) {
            KFImage(urlString: viewStore.profile?.profileImageUrl)
              .placeholder {
                Image(asset: LoveBirdAsset.icBirdProfileEmpty)
                  .resizable()
                  .background(Color(asset: LoveBirdAsset.gray02))
                  .border(Color(asset: LoveBirdAsset.gray05), width: 1)
                  .clipShape(Circle())
              }
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(size: 80)
              .clipShape(Circle())

            Image(asset: LoveBirdAsset.icBirdGray)
              .changeSize(to: .init(width: 24, height: 24))
              .changeColor(to: Color(asset: LoveBirdAsset.gray04))

            KFImage(urlString: viewStore.profile?.partnerImageUrl)
              .placeholder {
                Button { viewStore.send(.partnerProfileTapped) } label: {
                  Image(asset: LoveBirdAsset.icBirdProfileEmpty)
                    .resizable()
                    .background(Color(asset: LoveBirdAsset.gray02))
                    .border(Color(asset: LoveBirdAsset.gray05), width: 1)
                    .clipShape(Circle())
                }
              }
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(size: 80)
              .clipShape(Circle())
          }
        }

        HStack(alignment: .center, spacing: 0) {
          Spacer()

          Text("사랑한 지 ")
            .foregroundColor(.black)
            .font(.pretendard(size: 16, weight: .bold))

          Text(String(viewStore.profile?.dayCount ?? 0))
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
            Text(viewStore.profile?.nickname ?? "")
              .font(.pretendard(size: 14))
              .frame(maxWidth: .infinity, alignment: .trailing)

            Text(viewStore.profile?.partnerNickname ?? "달링이")
              .font(.pretendard(size: 14))
              .frame(maxWidth: .infinity, alignment: .leading)
              .foregroundStyle(viewStore.profile?.partnerNickname != nil ? .black : Color(asset: LoveBirdAsset.gray146))

          }

          Image(asset: LoveBirdAsset.icBird)
            .changeSize(to: .init(width: 24, height: 24))
            .changeColor(to: Color(asset: LoveBirdAsset.gray04))
        }
        .frame(height: 34)
      }
    }
  }

  var settingsView: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 0) {
        Button { viewStore.send(.editTapped) } label: {
          MyPageItemView(title: "회원 정보 수정")
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
      .padding(.horizontal, 16)
      .toolbar(viewStore.isCoupleLinkVisible ? .hidden : .visible, for: .tabBar)
    }
  }

  var coupleLinkBottomSheetView: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      CommonBottomSheetView(isOpen: viewStore.binding(
        get: \.isCoupleLinkVisible,
        send: MyPageAction.linkViewVisible
      )) {
        MyPageLinkView(store: store.scope(state: \.mypageLink, action: MyPageAction.mypageLink))
      }
    }
  }
}

#Preview {
  MyPageView(
    store: .init(
      initialState: MyPageState(profile: Profile.dummy),
      reducer: { MyPageCore() }
    )
  )
}
