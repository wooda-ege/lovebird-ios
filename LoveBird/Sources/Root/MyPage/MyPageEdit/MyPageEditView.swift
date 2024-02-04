//
//  MyPageEditView.swift
//  LoveBird
//
//  Created by 황득연 on 2/3/24.
//

import ComposableArchitecture
import SwiftUI

struct MyPageEditView: View {
  let store: StoreOf<MyPageEditCore>

  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      TopAlignedVStack {
        VStack(spacing: 20) {
          toolbar
          settingsView
        }
      }
    }
    .navigationBarBackButtonHidden(true)
  }
}

private extension MyPageEditView {
  var toolbar: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      CommonToolBar<EmptyView>(title: "회원정보 수정", backAction: { viewStore.send(.backTapped) })
    }
  }

  var settingsView: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 0) {
        Button { viewStore.send(.profileTapped) } label: {
          MyPageItemView(title: "프로필 정보")
        }

        Button { viewStore.send(.anniversaryTapped) } label: {
          MyPageItemView(title: "기념일 정보")
        }
      }
      .padding(.horizontal, 16)
    }
  }
}

#Preview {
  MyPageEditView(
    store: .init(
      initialState: MyPageEditState(),
      reducer: { MyPageEditCore() }
    )
  )
}
