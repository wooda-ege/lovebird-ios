//
//  MyPageProfileEditView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/08/13.
//

import ComposableArchitecture
import SwiftUI
import Kingfisher

struct MyPageProfileEditView: View {
  
  @FocusState var isNicknameFocused: Bool
  @FocusState var isEmailFocused: Bool
  @State var image: Image?
  @State private var showingAlert = false
  
  let store: StoreOf<MyPageProfileEditCore>
  
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack(spacing: 20) {
        toolbar
        profileView
        nicknameView
        emailView
        Spacer()
        logoutOrWithdrawalView
      }
      .sheet(isPresented: viewStore.binding(
        get: { $0.isImagePickerPresented },
        send: MyPageProfileEditAction.setImagePickerPresented
      )) {
        LocalImagePicker(selectedImage: viewStore.binding(
          get: { $0.selectedImage },
          send: MyPageProfileEditAction.selectImage
        ))
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

private extension MyPageProfileEditView {
  var toolbar: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      CommonToolBar(title: "프로필 정보", backAction: { viewStore.send(.backTapped) }) {
        Button {
          viewStore.send(.profileEditTapped)
        } label: {
          Text("수정")
            .foregroundColor(Color(.primary))
            .font(.pretendard(size: 16, weight: .bold))
        }
      }
    }
  }

  var profileView: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      Button { viewStore.send(.setImagePickerPresented(true)) } label: {
        Group {
          if let image = viewStore.selectedImage {
            Image(data: image)?
              .resizable()
              .aspectRatio(contentMode: .fill)
          } else {
            KFImage(urlString: viewStore.profile.profileImageUrl)
              .placeholder {
                Image(asset: LoveBirdAsset.icBirdProfileEmpty)
                  .resizable()
                  .background(Color(asset: LoveBirdAsset.gray02))
                  .border(Color(asset: LoveBirdAsset.gray05), width: 1)
                  .clipShape(Circle())
              }
              .resizable()
              .aspectRatio(contentMode: .fill)
          }
        }
        .frame(size: 80)
        .clipShape(Circle())
        .overlay(alignment: .bottomTrailing) {
          Image(asset: LoveBirdAsset.icCamera)
        }
      }
    }
  }

  var nicknameView: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 10) {
        LeftAlignedHStack {
          Text("닉네임")
            .foregroundColor(.black)
            .font(.pretendard(size: 16))

        }

        CommonTextField(
          text: viewStore.binding(get: \.nickname, send: MyPageProfileEditAction.nicknameEdited),
          placeholder: viewStore.profile.nickname,
          borderColor: viewStore.nicknameTextFieldState.color,
          isFocused: self.$isNicknameFocused
        )

        Text(viewStore.nicknameTextFieldState.description)
          .font(.pretendard(size: 14))
          .foregroundColor(viewStore.nicknameTextFieldState.color)
          .frame(maxWidth: .infinity, alignment: .leading)
      }
      .padding(.horizontal, 16)
    }
  }

  var emailView: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 10) {
        HStack {
          Text("이메일")
            .foregroundColor(.black)
            .font(.pretendard(size: 16))

          Spacer()
        }

        CommonTextField(
          text: viewStore.binding(get: \.email, send: MyPageProfileEditAction.emailEdited),
          placeholder: viewStore.profile.email,
          borderColor: viewStore.emailTextFieldState.color,
          isFocused: self.$isEmailFocused
        )

        Text(viewStore.emailTextFieldState.description)
          .font(.pretendard(size: 14))
          .foregroundColor(viewStore.emailTextFieldState.color)
          .frame(maxWidth: .infinity, alignment: .leading)
      }
      .padding(.horizontal, 16)
    }
  }

  var logoutOrWithdrawalView: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      HStack {
        Button { viewStore.send(.logoutTapped) } label: {
          HStack {
            Text("로그아웃")
          }
        }

        Divider()
          .frame(width: 1, height: 14)

        Button { viewStore.send(.withdrawalTapped) } label: {
          HStack {
            Text("회원탈퇴")
          }
        }
      }
      .foregroundColor(Color(asset: LoveBirdAsset.gray06))
      .font(.pretendard(size: 14))
      .padding(.bottom, 30)
    }
  }
}

#Preview {
  MyPageProfileEditView(
    store: .init(
      initialState: MyPageProfileEditState(profile: .dummy),
      reducer: { MyPageProfileEditCore() }
    )
  )
}
