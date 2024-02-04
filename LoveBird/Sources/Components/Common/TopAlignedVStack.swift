//
//  TopAlignedVStack.swift
//  LoveBird
//
//  Created by 황득연 on 2/3/24.
//

import SwiftUI

struct TopAlignedVStack<Content: View>: View {
  let spacing: CGFloat?
  let content: Content

  init(spacing: CGFloat? = nil, @ViewBuilder content: () -> Content) {
    self.spacing = spacing
    self.content = content()
  }

  var body: some View {
    VStack(spacing: spacing) {
      content
      Spacer()
    }
  }
}
