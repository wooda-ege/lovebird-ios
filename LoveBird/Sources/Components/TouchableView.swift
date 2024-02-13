//
//  TouchableView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/06/04.
//

import SwiftUI

struct TouchableView<Content: View>: View {
  let content: Content?

  init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }

  init() {
    self.content = nil
  }

  var body: some View {
    Group {
      if let content { content }
      else { EmptyView() }
    }
    .contentShape(Rectangle())
    .background(.clear)
  }
}

//struct TouchableStack_Previews: PreviewProvider {
//    static var previews: some View {
//        TouchableStack()
//    }
//}
