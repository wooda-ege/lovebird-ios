//
//  ScrollPositionModifier.swift
//  LoveBird
//
//  Created by 황득연 on 3/4/24.
//

import SwiftUI

struct ScrollPositionModifier: ViewModifier {
  @Binding var position: CGPoint

  func body(content: Content) -> some View {
    content
      .background(
        GeometryReader { geo -> Color in
          let origin = geo.frame(in: .global).origin
          DispatchQueue.main.async {
            self.position = origin
          }
          return Color.clear
        }
      )
  }
}
