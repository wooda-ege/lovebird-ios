//
//  OnboardingNicknameView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/20.
//

import SwiftUI
import ComposableArchitecture

struct OnboardingNicknameView: View {
  
  let store: StoreOf<OnboardingCore>
  @FocusState private var isFocused: Bool

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack(spacing: 10) {
        CommonTextField(
          text: viewStore.binding(get: \.nickname, send: OnboardingCore.Action.nicknameEdited),
          placeholder: "ex. 러버",
          borderColor: viewStore.nicknameTextFieldState.color,
          isFocused: self.$isFocused
        )
        .padding(.top, 24)
        .padding(.horizontal, 16)

        Text(viewStore.nicknameTextFieldState.description)
          .font(.pretendard(size: 16, weight: .regular))
          .foregroundColor(viewStore.nicknameTextFieldState.color)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.horizontal, 16)
        
        Spacer()

        CommonHorizontalButton(
          title: "다음",
          backgroundColor: viewStore.nicknameTextFieldState.isCorrect ? .black : Color(asset: LoveBirdAsset.gray05)
        ) {
          viewStore.send(.nextTapped)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(.white)
      .onTapGesture {
        self.isFocused = false
      }
      .onChange(of: self.isFocused) { isFocused in
        if !isFocused, viewStore.state.nicknameTextFieldState.isEditing {
          viewStore.send(.nicknameFocusFlashed)
        }
      }
    }
  }
}

struct OnboardingNicknameView_Previews: PreviewProvider {
  static var previews: some View {
    OnboardingNicknameView(
      store: Store(
        initialState: OnboardingState(auth: AuthRequest.dummy),
        reducer: OnboardingCore()
      )
    )
  }
}
