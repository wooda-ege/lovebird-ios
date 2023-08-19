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
  @State var image: Image?

  let store: StoreOf<MyPageProfileEditCore>

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack(spacing: 20) {
        CommonToolBar(title: "프로필 정보") {
          viewStore.send(.backButtonTapped)
        } content: {
          Button {
            viewStore.send(.editTapped)
          } label: {
            Text("수정")
              .foregroundColor(viewStore.nickname.isEmpty || viewStore.email.isEmpty ? Color(R.color.green234) : Color(R.color.primary))
              .font(.pretendard(size: 16, weight: .bold))
          }
        }

        // TODO: 득연 - iOS 16.0 으로 올리고 NavigationStack으로 리팩토링 후 진행할 예정
//        ZStack() {
//          Circle()
//            .fill(Color(R.color.gray03))
//            .frame(width: 80, height: 80)
//            .overlay(Image(R.image.ic_bird_edit), alignment: .center)
//        }
//        .overlay(Image(R.image.ic_camera_edit), alignment: .bottomTrailing)
//        .onTapGesture {
//          viewStore.send(.presentImagePicker)
//        }

        VStack(spacing: 10) {
          HStack {
            Text("닉네임")
              .foregroundColor(.black)
              .font(.pretendard(size: 14))

            Spacer()
          }

          CommonTextField(
            text: viewStore.binding(get: \.nickname, send: MyPageProfileEditAction.nicknameEdited),
            placeholder: viewStore.profile?.nickname ?? "",
            borderColor: viewStore.isNicknameFocused ? .black : Color(R.color.gray06),
            clearButtonTrailingPadding: 16,
            isFocused: self.$isNicknameFocused
          )
        }
        .padding(.horizontal, 16)

        VStack(spacing: 10) {
          HStack {
            Text("이메일")
              .foregroundColor(.black)
              .font(.pretendard(size: 14))

            Spacer()
          }

          CommonTextField(
            text: viewStore.binding(get: \.email, send: MyPageProfileEditAction.emailEdited),
            placeholder: viewStore.profile?.email ?? "",
            borderColor: viewStore.isEmailFocused ? .black : Color(R.color.gray06),
            clearButtonTrailingPadding: 16,
            isFocused: self.$isEmailFocused
          )
        }
        .padding(.horizontal, 16)

        Spacer()

        Button {
          viewStore.send(.deleteProfile)
        } label: {
          Text("회원탈퇴")
            .foregroundColor(Color(R.color.gray06))
            .font(.pretendard(size: 14))
            .padding(.bottom, 30)
        }
      }
      .navigationBarBackButtonHidden(true)
      .ifTapped {
        viewStore.send(.isFocused(.none))
        self.isNicknameFocused = false
        self.isEmailFocused = false
      }
      .onAppear {
        viewStore.send(.viewAppear)
      }
      .onChange(of: self.isNicknameFocused) { newValue in
        if newValue { viewStore.send(.isFocused(.nickname)) }
      }
      .onChange(of: self.isEmailFocused) { newValue in
        if newValue { viewStore.send(.isFocused(.email)) }
      }
    }
  }
}

//struct MyPageProfileEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        MyPageProfileEditView()
//    }
//}
