//
//  CommonTextField.swift
//  LoveBird
//
//  Created by 황득연 on 2023/06/30.
//

import SwiftUI

struct CommonTextField: View {
  
  @FocusState var isFocused: Bool
  let placeholder: String
  var textBinding: Binding<String>
  var color: Color

  var body: some View {
    TextField(self.placeholder, text: self.textBinding)
      .font(.pretendard(size: 18, weight: .regular))
      .foregroundColor(.black)
      .padding(.vertical, 15)
      .padding(.leading, 16)
      .padding(.trailing, 48)
      .focused($isFocused)
      .showClearButton(self.textBinding)
      .frame(width: UIScreen.width - 32)
      .roundedBackground(cornerRadius: 12, color: color)
  }
}

//struct CommonTextField_Previews: PreviewProvider {
//  static var previews: some View {
//    CommonTextField()
//  }
//}
