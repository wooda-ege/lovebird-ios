//
//  OnboardingEmailView.swift
//  LoveBird
//
//  Created by 이예은 on 2023/06/30.
//

import SwiftUI
import ComposableArchitecture

struct OnboardingEmailView: View {
  let store: StoreOf<OnboardingCore>
  @FocusState private var isFocused: Bool
  
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack(spacing: 10) {
        CommonTextField(
          text: viewStore.binding(get: \.email, send: OnboardingAction.emailEdited),
          placeholder: "love@bird.com",
          borderColor: viewStore.emailTextFieldState.color,
          isFocused: self.$isFocused
        )
        .padding(.top, 24)
        .padding(.horizontal, 16)

        Text(viewStore.emailTextFieldState.description)
          .font(.pretendard(size: 16, weight: .regular))
          .foregroundColor(viewStore.emailTextFieldState.color)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.horizontal, 16)

        Spacer()

        CommonHorizontalButton(
          title: "다음",
          backgroundColor: viewStore.emailTextFieldState.isCorrect ? .black : Color(R.color.gray05)
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
        if !isFocused, viewStore.state.emailTextFieldState.isEditing {
          viewStore.send(.emailFocusFlashed)
        }
      }
    }
  }
}

//struct OnboardingEmailView_Previews: PreviewProvider {
//  static var previews: some View {
//    OnboardingEmailView(store: Store(initialState: OnboardingCore.State(), reducer: OnboardingCore()))
//  }
//}

