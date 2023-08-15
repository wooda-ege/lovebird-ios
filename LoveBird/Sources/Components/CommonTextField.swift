//
//  CommonTextField.swift
//  LoveBird
//
//  Created by 황득연 on 2023/06/30.
//

import SwiftUI

struct CommonTextField: View {
  @Binding var text: String
  let placeholder: String
  let borderColor: Color
  let clearButtonTrailingPadding: CGFloat
  var isFocused: FocusState<Bool>.Binding

  var body: some View {
    TextField(self.placeholder, text: self.$text)
      .font(.pretendard(size: 18))
      .background(.clear)
      .padding([.vertical, .leading], 16)
      .padding(.trailing, 48)
      .frame(maxWidth: .infinity, alignment: .leading)
      .focused(self.isFocused)
      .showClearButton(
        self.$text,
        isFocused: self.isFocused.wrappedValue,
        trailingPadding: self.clearButtonTrailingPadding
      )
      .roundedBackground(
        cornerRadius: 12,
        color: self.borderColor
      )
  }
}

//struct CommonTextField_Previews: PreviewProvider {
//  static var previews: some View {
//    CommonTextField()
//  }
//}
