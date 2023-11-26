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
            viewStore.send(.editTapped)
          } label: {
            Text("수정")
              .foregroundColor(viewStore.nickname.isEmpty || viewStore.email.isEmpty ? Color(asset: LoveBirdAsset.green234) : Color(asset: LoveBirdAsset.primary))
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
              .font(.pretendard(size: 14))
            
            Spacer()
          }
          
          CommonTextField(
            text: viewStore.binding(get: \.nickname, send: MyPageProfileEditAction.nicknameEdited),
            placeholder: viewStore.profile?.nickname ?? "",
            borderColor: viewStore.isNicknameFocused ? .black : Color(asset: LoveBirdAsset.gray06),
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
            borderColor: viewStore.isEmailFocused ? .black : Color(asset: LoveBirdAsset.gray06),
            clearButtonTrailingPadding: 16,
            isFocused: self.$isEmailFocused
          )
        }
        .padding(.horizontal, 16)
        
        Spacer()
        
        Button {
          self.showingAlert.toggle()
          viewStore.send(.withdrawalTapped)
        } label: {
          Text("회원탈퇴")
            .foregroundColor(Color(asset: LoveBirdAsset.gray06))
            .font(.pretendard(size: 14))
            .padding(.bottom, 30)
        }
        .alert(isPresented: $showingAlert) {
          Alert(title: Text("탈퇴가 완료되었습니다."), message: nil, dismissButton: .default(Text("확인")))
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

#Preview {
  MyPageProfileEditView(
    store: .init(
      initialState: MyPageProfileEditState(),
      reducer: { MyPageProfileEditCore() }
    )
  )
}
