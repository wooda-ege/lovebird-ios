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
  @StateObject private var keyboard = KeyboardResponder()
  
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack(spacing: 10) {
        CommonTextField(
          text: viewStore.binding(get: \.nickname, send: OnboardingCore.Action.nicknameEdited),
          placeholder: "ex. 러버",
          borderColor: viewStore.nicknameTextFieldState.color,
          isFocused: self.$isFocused
        )
        .padding(.horizontal, 16)

        Text(viewStore.nicknameTextFieldState.description)
          .font(.pretendard(size: 16, weight: .regular))
          .foregroundColor(viewStore.nicknameTextFieldState.color)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.horizontal, 16)
        
        Spacer()
        
        Button {
          viewStore.send(.nextTapped)
          self.hideKeyboard()
        } label: {
          TouchableStack {
            Text(R.string.localizable.common_next)
              .font(.pretendard(size: 16, weight: .semiBold))
              .foregroundColor(.white)
          }
        }
        .frame(height: 56)
        .background(viewStore.nicknameTextFieldState.isCorrect ? .black : Color(R.color.gray05))
        .cornerRadius(12)
        .padding(.horizontal, 16)
        .padding(.bottom, keyboard.currentHeight == 0 ? 20 + UIApplication.edgeInsets.bottom : keyboard.currentHeight + 20)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(.white)
      .onTapGesture {
        self.isFocused = false
      }
      .onChange(of: self.isFocused) { isFocused in
        if !isFocused, viewStore.state.nicknameTextFieldState.isEditing {
          viewStore.send(.nicknameTextFieldStateChanged(.none))
        }
      }
    }
  }
}

//struct OnboardingNicknameView_Previews: PreviewProvider {
//  static var previews: some View {
//    OnboardingNicknameView(store: Store(initialState: OnboardingCore.State(), reducer: OnboardingCore()))
//  }
//}
