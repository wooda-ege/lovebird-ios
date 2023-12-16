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
        .rotationEffect(.degrees(180))
    }
    .rotationEffect(.degrees(180))
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .scrollIndicators(.hidden)
  }
}
