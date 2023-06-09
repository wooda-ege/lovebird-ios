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
  @FocusState private var isNameFieldFocused: Bool
  @StateObject private var keyboard = KeyboardResponder()
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      VStack {
        Spacer().frame(height: 24)
        
        Text(R.string.localizable.onboarding_nickname_title)
          .font(.pretendard(size: 20, weight: .bold))
          .foregroundColor(.black)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.leading, 16)
        
        Text(R.string.localizable.onboarding_nickname_description)
          .font(.pretendard(size: 16, weight: .regular))
          .foregroundColor(Color(R.color.gray07))
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.top, 12)
          .padding(.leading, 16)
        
        Spacer().frame(height: 48)
        
        TextField("ex. 러버", text: viewStore.binding(get: \.nickname, send: OnboardingCore.Action.nicknameEdited))
          .font(.pretendard(size: 18, weight: .regular))
          .foregroundColor(.black)
          .padding(.vertical, 15)
          .padding(.leading, 16)
          .padding(.trailing, 48)
          .focused($isNameFieldFocused)
          .showClearButton(viewStore.binding(get: \.nickname, send: OnboardingCore.Action.nicknameEdited))
          .frame(width: UIScreen.width - 32)
          .roundedBackground(cornerRadius: 12, color: viewStore.textFieldState.color)
        
        Text(viewStore.textFieldState.description)
          .font(.pretendard(size: 16, weight: .regular))
          .foregroundColor(viewStore.textFieldState.color)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.top, 10)
          .padding(.leading, 16)
        
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
        .background(viewStore.textFieldState == .correct ? .black : Color(R.color.gray05))
        .cornerRadius(12)
        .padding(.horizontal, 16)
        .padding(.bottom, keyboard.currentHeight == 0 ? 20 + UIApplication.edgeInsets.bottom : keyboard.currentHeight + 20)
      }
      .background(.white)
      .onTapGesture {
        self.isNameFieldFocused = false
      }
      .onChange(of: isNameFieldFocused) { newValue in
        if viewStore.nickname.isEmpty {
          viewStore.send(.textFieldStateChanged(newValue ? .editing : .none))
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(.white)
    }
  }
}

struct OnboardingNicknameView_Previews: PreviewProvider {
  static var previews: some View {
    OnboardingNicknameView(store: Store(initialState: OnboardingCore.State(), reducer: OnboardingCore()))
  }
}
