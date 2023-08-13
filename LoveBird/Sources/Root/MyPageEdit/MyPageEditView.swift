//
//  MyPageEditView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/08/12.
//

import Foundation

import ComposableArchitecture
import SwiftUI

struct MyPageEditView: View {
  let store: StoreOf<MyPageEditCore>

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack() {
        CommonToolBar<EmptyView>(title: "회원정보 수정") {
          viewStore.send(.backButtonTapped)
        }

        VStack {
          NavigationLinkStore(
            self.store.scope(state: \.$myPageProfileEdit, action: MyPageEditAction.myPageProfileEdit)
          ) {
            viewStore.send(.profileEditTapped)
          } destination: { store in
            MyPageProfileEditView(store: store)
          } label: {
            HStack(alignment: .center) {
              Text("프로필 정보")
                .font(.pretendard(size: 16))
                .padding(.leading, 16)

              Spacer()

              Image(R.image.ic_arrow_right)
                .padding(.trailing, 20)
            }
            .frame(height: 64)
            .frame(maxWidth: .infinity)
            .bottomBorder()
          }

          NavigationLinkStore(
            self.store.scope(state: \.$myPageAnniversaryEdit, action: MyPageEditAction.myPageAnniversaryEdit)
          ) {
            viewStore.send(.anniversaryEditTapped)
          } destination: { store in
            MyPageAnniversaryEditView(store: store)
          } label: {
            HStack(alignment: .center) {
              Text("기념일 정보")
                .font(.pretendard(size: 16))
                .padding(.leading, 16)

              Spacer()

              Image(R.image.ic_arrow_right)
                .padding(.trailing, 20)
            }
            .frame(height: 64)
            .frame(maxWidth: .infinity)
            .bottomBorder()
          }
        }
        .padding(.horizontal, 16)

        Spacer()
      }
      .navigationBarBackButtonHidden(true)
    }
  }
}

//struct MyPageEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        MyPageEditView()
//    }
//}
