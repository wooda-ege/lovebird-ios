//
//  MyPageProfileEditView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/08/13.
//

import ComposableArchitecture
import SwiftUI

struct MyPageProfileEditView: View {

  @FocusState var isNicknameFocused: Bool
  @FocusState var isEmailFocused: Bool

  let store: StoreOf<MyPageProfileEditCore>

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack(spacing: 20) {
        CommonToolBar(title: "프로필 정보") {
          viewStore.send(.backButtonTapped)
        } content: {
          Text("수정")
            .foregroundColor(.black)
            .font(.pretendard(size: 16, weight: .bold))
        }

        ZStack(alignment: .bottomTrailing) {
          Circle()
            .fill(Color(R.color.gray03))
            .frame(width: 80, height: 80)
            .overlay(Image(R.image.ic_bird_edit), alignment: .center)
        }
        .overlay(Image(R.image.ic_camera_edit), alignment: .bottomTrailing)
        .onTapGesture {
        }

        VStack(spacing: 10) {
          HStack {
            Text("닉네임")
              .foregroundColor(.black)
              .font(.pretendard(size: 14))

            Spacer()
          }

          let nicknameBinding = viewStore.binding(get: \.nickname, send: MyPageProfileEditAction.nicknameEdited)
          TextField(viewStore.profile?.nickname ?? "", text: nicknameBinding)
            .font(.pretendard(size: 18))
            .background(.clear)
            .padding(.leading, 16)
            .padding(.trailing, 48)
            .padding(.vertical, 16)
            .focused($isNicknameFocused)
            .frame(maxWidth: .infinity, alignment: .leading)
            .showClearButton(nicknameBinding, isFocused: self.isNicknameFocused, trailingPadding: 16)
            .roundedBackground(
              cornerRadius: 12,
              color: viewStore.isNicknameFocused ? .black : Color(R.color.gray06)
            )
            .onChange(of: self.isNicknameFocused) { newValue in
              if newValue {
                viewStore.send(.isFocused(.nickname))
              }
            }
        }
        .padding(.horizontal, 16)

        VStack(spacing: 10) {
          HStack {
            Text("이메일")
              .foregroundColor(.black)
              .font(.pretendard(size: 14))

            Spacer()
          }

          let emailBinding = viewStore.binding(get: \.email, send: MyPageProfileEditAction.emailEdited)
          TextField(viewStore.profile?.email ?? "", text: emailBinding)
            .font(.pretendard(size: 18))
            .background(.clear)
            .padding(.leading, 16)
            .padding(.trailing, 48)
            .padding(.vertical, 16)
            .focused($isEmailFocused)
            .frame(maxWidth: .infinity, alignment: .leading)
            .showClearButton(emailBinding, isFocused: self.isEmailFocused, trailingPadding: 16)
            .roundedBackground(
              cornerRadius: 12,
              color: viewStore.isEmailFocused ? .black : Color(R.color.gray06)
            )
            .onChange(of: self.isEmailFocused) { newValue in
              if newValue {
                viewStore.send(.isFocused(.email))
              }
            }
        }
        .padding(.horizontal, 16)

        Spacer()
      }
      .background(Color.white.onTapGesture {
        viewStore.send(.isFocused(.none))
        self.isNicknameFocused = false
        self.isEmailFocused = false
      })
      .navigationBarBackButtonHidden(true)
      .onAppear {
        viewStore.send(.viewAppear)
      }
    }
  }
}

//struct MyPageProfileEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        MyPageProfileEditView()
//    }
//}
