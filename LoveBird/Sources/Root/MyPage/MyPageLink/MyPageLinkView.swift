//
//  MyPageLinkView.swift
//  LoveBird
//
//  Created by 이예은 on 1/7/24.
//

import SwiftUI
import ComposableArchitecture

struct MyPageLinkView: View {
  
  let store: StoreOf<MyPageLinkCore>
  @FocusState private var isTextFieldFocused: Bool
  @StateObject private var keyboard = KeyboardResponder()

  init(store: StoreOf<MyPageLinkCore>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
        VStack(alignment: .leading, spacing: 0) {
          Text(LoveBirdStrings.onboardingInvitationTitle)
            .font(.pretendard(size: 20, weight: .bold))
            .foregroundColor(.black)
            .frame(maxWidth: .infinity, alignment: .leading)

          Spacer().frame(height: 12)
          
          Text(LoveBirdStrings.onboardingInvitationDescription)
            .font(.pretendard(size: 16))
            .foregroundColor(Color(asset: LoveBirdAsset.gray07))
            .frame(maxWidth: .infinity, alignment: .leading)
          
          Spacer().frame(height: 48)
          
          HStack(alignment: .center) {
            Text(viewStore.invitationCode)
              .font(.pretendard(size: 16, weight: .semiBold))
              .foregroundColor(.black)
              .lineLimit(1)
            
            Spacer()
            
            Button { viewStore.send(.shareVisible(true)) } label: {
              Text("공유")
                .font(.pretendard(size: 14, weight: .bold))
                .foregroundColor(.white)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(.black)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
          }
          .padding(.vertical, 12)
          .padding(.horizontal, 16)
          .frame(height: 56)
          .background(Color(asset: LoveBirdAsset.gray02))
          .clipShape(RoundedRectangle(cornerRadius: 12))
          
          Spacer()
            .frame(height: 24)
          
          VStack(alignment: .leading) {
            Text(LoveBirdStrings.onboardingInvitationQuestion)
              .font(.pretendard(size: 14, weight: .regular))
            
            let textBinding = viewStore.binding(get: \.invitationInputCode, send: MyPageLinkAction.invitationCodeEdited)
            CommonTextField(
              text: textBinding,
              placeholder: "초대코드 입력",
              borderColor: isTextFieldFocused ? .black : Color(asset: LoveBirdAsset.gray06),
              isFocused: self.$isTextFieldFocused
            )
          }
          
          Button {
            viewStore.send(.confirmButtonTapped)
            hideKeyboard()
          } label: {
            CenterAlignedHStack {
              Text(LoveBirdStrings.onboardingInvitationConnect)
                .font(.pretendard(size: 16, weight: .semiBold))
                .foregroundColor(.white)
            }
          }
          .frame(height: 56)
          .background(.black)
          .clipShape(RoundedRectangle(cornerRadius: 12))
          .padding(.bottom, isTextFieldFocused ? keyboard.currentHeight : 0)
          .padding(.top, 20)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
        .background(.white)
        .sheet(isPresented: viewStore.binding(get: \.isShareSheetShown, send: MyPageLinkAction.shareVisible)) {
          ActivityViewController(
            isPresented: viewStore.binding(get: \.isShareSheetShown, send: MyPageLinkAction.shareVisible),
            activityItems: [viewStore.invitationCode]
          )
        }
        .onAppear {
          viewStore.send(.viewAppear)
        }
        .onTapGesture {
          isTextFieldFocused = false
        }
    }
  }
}

#Preview {
  MyPageLinkView(store: Store(initialState: MyPageLinkState(), reducer: { MyPageLinkCore() }))
}
