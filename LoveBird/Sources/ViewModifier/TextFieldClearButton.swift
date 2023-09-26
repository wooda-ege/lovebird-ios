//
//  TextFieldClearButton.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/21.
//

import SwiftUI

struct TextFieldClearButton: ViewModifier {
  @Binding var fieldText: String
  let isFocused: Bool
  let trailingPadding: CGFloat
  
  func body(content: Content) -> some View {
    content
      .overlay {
        if self.fieldText.isNotEmpty, self.isFocused {
          HStack {
            Spacer()

            Button { self.fieldText = "" } label: {
              Image(systemName: "multiply.circle.fill")
            }
            .padding(.trailing, self.trailingPadding)
          }
        }
      }
  }
}
