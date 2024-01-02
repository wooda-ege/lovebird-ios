//
//  LeftAlignedHStack.swift
//  LoveBird
//
//  Created by 황득연 on 12/31/23.
//

import SwiftUI

struct LeftAlignedHStack<Content: View>: View {
  let content: Content

  init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }

  var body: some View {
    HStack {
      content
      Spacer()
    }
  }
}
