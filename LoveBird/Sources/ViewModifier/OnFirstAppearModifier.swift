//
//  OnFirstAppearModifier.swift
//  LoveBird
//
//  Created by 황득연 on 2/29/24.
//

import SwiftUI

struct OnFirstAppearModifier: ViewModifier {
  @State private var isFirstAppeared = false
  let action: () -> Void

  func body(content: Content) -> some View {
    content
      .onAppear {
        guard isFirstAppeared == false else { return }
        isFirstAppeared = true
        action()
      }
  }
}
