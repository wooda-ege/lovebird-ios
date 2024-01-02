//
//  CenterAlignedHStack.swift
//  LoveBird
//
//  Created by 황득연 on 1/1/24.
//

import SwiftUI

struct CenterAlignedHStack<Content: View>: View {
  let content: Content

  init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }

  var body: some View {
    HStack {
      Spacer()
      content
      Spacer()
    }
  }
}
