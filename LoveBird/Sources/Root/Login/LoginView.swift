//
//  LoginView.swift
//  LoveBird
//
//  Created by 이예은 on 2023/06/29.
//

import ComposableArchitecture
import UIKit
import SwiftUI
import Foundation

struct LoginView: View {
  let store: StoreOf<LoginCore>

  init(store: StoreOf<LoginCore>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack {
        LeftAlignedHStack {
          Image(asset: LoveBirdAsset.imgPinkbird)
            .resizable()
            .frame(width: 80, height: 80)
            .padding(.leading, 16)
            .padding(.top, 40)
        }
        
        VStack(alignment: .leading, spacing: 0) {
          LeftAlignedHStack {
            Text("함께 쌓는")
              .font(.pretendard(size: 32))
          }

          LeftAlignedHStack {
            Text("추억 다이어리")
              .font(.pretendard(size: 32, weight: .bold))
          }
          .padding(.top, 4)

          LeftAlignedHStack {
            HStack {
              Text("연인과의 데이트를 ")
                .font(.pretendard(size: 16))
              + Text("러브버드")
                .font(.pretendard(size: 16, weight: .bold))
              + Text("에서 기록해보세요")
                .font(.pretendard(size: 16))
            }
            .foregroundColor(Color(asset: LoveBirdAsset.gray07))
          }
          .padding(.top, 8)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
        .padding(.leading, 24)

        Spacer()

        VStack(spacing: 8) {
          Button { viewStore.send(.kakaoTapped) } label: {
            LoginTypeView(type: .kakao)
          }

          Button { viewStore.send(.appleTapped) } label: {
            LoginTypeView(type: .apple)
          }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
      }
      .onAppear {
        viewStore.send(.viewAppear)
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
