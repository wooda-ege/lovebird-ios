//
//  GetHeightModifier.swift
//  LoveBird
//
//  Created by 황득연 on 2023/07/02.
//

import SwiftUI

struct GetHeightModifier: ViewModifier {
  @Binding var height: CGFloat

  func body(content: Content) -> some View {
    content
      .background(
        GeometryReader { geo -> Color in
          DispatchQueue.main.async {
            self.height = geo.size.height
          }
          return Color.clear
        }
      )
  }
}

extension View {
  func onChangeHeight(_ height: Binding<CGFloat>) -> some View {
    self.modifier(GetHeightModifier(height: height))
  }
}
