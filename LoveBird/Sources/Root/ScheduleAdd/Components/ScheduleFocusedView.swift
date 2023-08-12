//
//  ScheduleAddFocusedView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/06/30.
//

import Foundation

import SwiftUI

struct ScheduleFocusedView<Content: View>: View {

  let isFocused: Bool
  let content: Content

  init(isFocused: Bool = false, @ViewBuilder content: () -> Content) {
    self.isFocused = isFocused
    self.content = content()
  }

  var body: some View {
    HStack(alignment: .center) {
      self.content
    }
    .frame(maxWidth: .infinity)
    .padding(16)
    .background(
      Group {
        if self.isFocused {
          RoundedRectangle(cornerRadius: 12)
            .strokeBorder(.black, lineWidth: 1)
        } else {
          RoundedRectangle(cornerRadius: 12)
            .fill(Color(R.color.gray02))
        }
      }
    )
  }
}

//struct CommonFocusedView_Previews: PreviewProvider {
//  static var previews: some View {
//    CommonFocusedView()
//  }
//}
