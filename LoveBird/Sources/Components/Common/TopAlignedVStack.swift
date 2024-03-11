//
//  TopAlignedVStack.swift
//  LoveBird
//
//  Created by 황득연 on 2/3/24.
//

import SwiftUI

struct TopAlignedVStack<Content: View>: View {
  let alignment: HorizontalAlignment
  let spacing: CGFloat?
  let content: Content

  init(
    alignment: HorizontalAlignment = .center,
    spacing: CGFloat? = nil,
    @ViewBuilder content: () -> Content
  ) {
    self.alignment = alignment
    self.spacing = spacing
    self.content = content()
  }

  var body: some View {
    VStack(alignment: alignment, spacing: spacing) {
      content
      Spacer()
    }
  }
}
