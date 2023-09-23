//
//  ResignKeyboardOnDragGesture.swift
//  LoveBird
//
//  Created by 이예은 on 2023/06/06.
//

import SwiftUI

struct ResignKeyboardOnDragGesture: ViewModifier {
  var gesture = DragGesture().onChanged { _ in
    UIApplication.shared.endEditing(true)
  }

  func body(content: Content) -> some View {
    content
      .gesture(gesture)
  }
}
