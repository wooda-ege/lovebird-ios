//
//  Image+Extension.swift
//  LoveBird
//
//  Created by 황득연 on 2023/07/09.
//

import SwiftUI

extension View {
  func changeColor(to color: Color) -> some View {
    if let image = self as? Image {
        return AnyView(
            image.renderingMode(.template)
              .foregroundColor(color)
        )
    }
    return AnyView(self)
  }

  func changeSize(to size: CGSize) -> some View {
    if let image = self as? Image {
        return AnyView(
            image.resizable()
                .frame(width: size.width, height: size.height)
        )
    }
    return AnyView(self)
  }
}
