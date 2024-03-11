//
//  CenterAlignedHStack.swift
//  LoveBird
//
//  Created by 황득연 on 1/1/24.
//

import SwiftUI

struct CenterAlignedHStack<Content: View>: View {
  private let alignment: VerticalAlignment
  private let spacing: CGFloat?
  private let content: Content

  init(alignment: VerticalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: () -> Content) {
    self.alignment = alignment
    self.spacing = spacing
    self.content = content()
  }

  var body: some View {
    HStack(alignment: alignment, spacing: spacing) {
      Spacer()
      content
      Spacer()
    }
  }
}
