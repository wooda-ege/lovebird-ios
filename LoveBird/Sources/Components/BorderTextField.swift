//
//  BorderTextField.swift
//  LoveBird
//
//  Created by 황득연 on 2023/08/13.
//

//import SwiftUI
//
//struct BorderTextField: View {
//
//  let placeholder: String
//  @Binding var text: String
//
//  init(placeholder: String = "") {
//    self.placeholder = placeholder
//  }
//
//  var body: some View {
//    HStack {
//      TextField(self.placeholder, text: self.text)
//        .font(.pretendard(size: 18, weight: .regular))
//        .foregroundColor(.black)
//        .padding(.leading, 15)
//        .padding(.leading, 16)
//        .padding(.trailing, 48)
//        .focused($isNameFieldFocused)
//        .showClearButton(viewStore.binding(get: \.nickname, send: OnboardingCore.Action.nicknameEdited))
//        .roundedBackground(cornerRadius: 12, color: viewStore.textFieldState.color)
//    }
//    .padding(.horizontal, 16)
//  }
//}

//struct CommonFocusedView_Previews: PreviewProvider {
//  static var previews: some View {
//    CommonFocusedView()
//  }
//}
