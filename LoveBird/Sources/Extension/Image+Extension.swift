//
//  Image+Extension.swift
//  LoveBird
//
//  Created by 황득연 on 2023/07/09.
//

import SwiftUI

extension Image {
  func changeColor(to color: Color) -> some View {
    self.renderingMode(.template)
      .foregroundColor(color)
  }
}
