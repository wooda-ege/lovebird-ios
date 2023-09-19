//
//  TouchableStack.swift
//  LoveBird
//
//  Created by 황득연 on 2023/06/04.
//

import SwiftUI

struct TouchableStack<Content: View>: View {
  let content: Content
  
  init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }
  
  var body: some View {
    self.content
      .frame(maxWidth: .infinity)
      .contentShape(Rectangle())
      .background(.clear)
  }
}

//struct TouchableStack_Previews: PreviewProvider {
//    static var previews: some View {
//        TouchableStack()
//    }
//}
