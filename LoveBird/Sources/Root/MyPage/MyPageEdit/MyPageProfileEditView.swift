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
  @State private var showingAlert = false
  
  let store: StoreOf<MyPageProfileEditCore>
  
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack(spacing: 20) {
        CommonToolBar(title: "프로필 정보", backAction: { viewStore.send(.backTapped) }) {
          Button {
            viewStore.send(.profileEditTapped)
          } label: {
            Text("수정")
              .foregroundColor(Color(.gray12))
              .font(.pretendard(size: 16, weight: .bold))
          }
        }
        
        // TODO: 득연 - iOS 16.0 으로 올리고 NavigationStack으로 리팩토링 후 진행할 예정
        //        ZStack() {
        //          Circle()
        //            .fill(Color(asset: LoveBirdAsset.gray03))
        //            .frame(width: 80, height: 80)
        //            .overlay(Image(asset: LoveBirdAsset.icBirdEdit), alignment: .center)
        //        }
        //        .overlay(Image(asset: LoveBirdAsset.icCameraEdit), alignment: .bottomTrailing)
        //        .onTapGesture {
        //          viewStore.send(.presentImagePicker)
        //        }
        
        VStack(spacing: 10) {
          HStack {
            Text("닉네임")
              .foregroundColor(.black)
              .font(.pretendard(size: 16))
            
            Spacer()
          }
          
          CommonTextField(
            text: viewStore.binding(get: \.nickname, send: MyPageProfileEditAction.nicknameEdited),
            placeholder: viewStore.profile.nickname,
            borderColor: viewStore.isNicknameFocused ? .black : Color(asset: LoveBirdAsset.gray06),
            isFocused: self.$isNicknameFocused
          )

          Text(viewStore.nicknameTextFieldState.description)
            .font(.pretendard(size: 14))
            .foregroundColor(viewStore.nicknameTextFieldState.color)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 16)
        
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
            borderColor: viewStore.isEmailFocused ? .black : Color(asset: LoveBirdAsset.gray06),
            isFocused: self.$isEmailFocused
          )

          Text(viewStore.emailTextFieldState.description)
            .font(.pretendard(size: 14))
            .foregroundColor(viewStore.emailTextFieldState.color)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 16)
        
        Spacer()

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

#Preview {
  MyPageProfileEditView(
    store: .init(
      initialState: MyPageProfileEditState(profile: .dummy),
      reducer: { MyPageProfileEditCore() }
    )
  )
}
