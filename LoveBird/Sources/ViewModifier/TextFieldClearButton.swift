//
//  TextFieldClearButton.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/21.
//

import SwiftUI

struct TextFieldClearButton: ViewModifier {
  @Binding var fieldText: String
  var trailingPadding: CGFloat
  
  func body(content: Content) -> some View {
    content
      .overlay {
        if self.fieldText.isNotEmpty {
          HStack {
            Spacer()
            Button {
              self.fieldText = ""
            } label: {
              Image(systemName: "multiply.circle.fill")
            }
            .foregroundColor(.secondary)
            .padding(.trailing, self.trailingPadding)
          }
        }
      }
  }
}
