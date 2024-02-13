//
//  HomeLinkSuccessView.swift
//  LoveBird
//
//  Created by 이예은 on 1/11/24.
//

import SwiftUI
import ComposableArchitecture
import Kingfisher

struct HomeLinkSuccessView: View {
  let store: StoreOf<HomeCore>
  
  // MARK: - Body
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      Group {
        if let profile = viewStore.profile {
          ZStack {
            TouchableView<EmptyView>()
              .frame(maxWidth: .infinity, maxHeight: .infinity)

            CenterAlignedHStack {
              VStack(spacing: 0) {
                HStack(spacing: 0) {
                  Text(profile.partnerNickname ?? "달링이")
                    .foregroundStyle(Color(asset: LoveBirdAsset.green126))
                    .bold()
                  Text("님과 연결됐어요!")
                    .bold()
                }
                .font(.pretendard(size: 16, weight: .bold))
                .padding(.top, 32)

                Spacer()
                  .frame(height: 8)

                Text("러브버드에서 행복한 추억을 쌓아보세요!")
                  .font(.pretendard(size: 14))
                  .foregroundStyle(Color(asset: LoveBirdAsset.gray07))

                Spacer()
                  .frame(height: 24)

                HStack(spacing: 2) {
                  if let urlString = viewStore.profile?.profileImageUrl {
                    Circle()
                      .fill(Color(asset: LoveBirdAsset.gray02))
                      .overlay(KFImage(URL(string: urlString)).resizable(), alignment: .center)
                      .frame(width: 96, height: 96)
                      .overlay(
                        Circle()
                          .stroke(Color(asset: LoveBirdAsset.gray05), lineWidth: 1)
                      )
                  } else {
                    Circle()
                      .fill(Color(asset: LoveBirdAsset.gray02))
                      .frame(width: 96, height: 96)
                      .overlay(Image(asset: LoveBirdAsset.icBirdEdit), alignment: .center)
                      .overlay(
                        Circle()
                          .stroke(Color(asset: LoveBirdAsset.gray05), lineWidth: 1)
                      )
                  }

                  Image(asset: LoveBirdAsset.imgPinkbird)
                    .changeSize(to: .init(width: 36, height: 36))

                  if let urlString = viewStore.profile?.partnerImageUrl {
                    Circle()
                      .fill(Color(asset: LoveBirdAsset.gray02))
                      .overlay(KFImage(URL(string: urlString)).resizable(), alignment: .center)
                      .frame(width: 96, height: 96)
                      .overlay(
                        Circle()
                          .stroke(Color(asset: LoveBirdAsset.gray05), lineWidth: 1)
                      )
                  } else {
                    Circle()
                      .fill(Color(asset: LoveBirdAsset.gray02))
                      .frame(width: 96, height: 96)
                      .overlay(Image(asset: LoveBirdAsset.icBirdEdit), alignment: .center)
                      .overlay(
                        Circle()
                          .stroke(Color(asset: LoveBirdAsset.gray05), lineWidth: 1)
                      )
                  }
                }

                Spacer()
                  .frame(height: 32)

                HStack(spacing: 4) {
                  CommonHorizontalButton(
                    title: "닫기",
                    backgroundColor: .white,
                    foregroundColor: .black
                  ) {
                    viewStore.send(.linkSuccessCloseTapped)
                  }

                  CommonHorizontalButton(
                    title: "첫번째 기록하기",
                    backgroundColor: .black
                  ) {
                    viewStore.send(.linkSuccessCloseTapped)
                    viewStore.send(.todoDiaryTapped)
                  }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
              }
            }
            .background(.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.16), radius: 12)
          }
          .frame(maxWidth: .infinity)
        } else {
          EmptyView()
        }
      }
    }
  }
}

#Preview {
  HomeLinkSuccessView(
    store: Store(
      initialState: HomeState(),
      reducer: { HomeCore() }
    )
  )
}
