//
//  TimelineScrollView.swift
//  LoveBird
//
//  Created by 황득연 on 11/26/23.
//

import SwiftUI

struct TimelineScrollView<Content: View>: View {

  private let content: Content

  init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }

  var body: some View {
    ScrollView {
      content
        .scaleEffect(x: 1, y: -1)
    }
    .scaleEffect(x: 1, y: -1)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .scrollIndicators(.hidden)
  }
}
