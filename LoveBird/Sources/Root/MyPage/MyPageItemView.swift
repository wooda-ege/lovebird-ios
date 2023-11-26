//
//  MyPageItemView.swift
//  LoveBird
//
//  Created by 황득연 on 11/26/23.
//

import SwiftUI

struct MyPageItemView<Content: View>: View {

  private let title: String
  private let content: Content?

  init(title: String, @ViewBuilder content: () -> Content) {
    self.title = title
    self.content = content()
  }

  init(title: String) where Content == EmptyView {
    self.title = title
    self.content = nil
  }

  var body: some View {
    HStack(alignment: .center) {
      Text(title)
        .font(.pretendard(size: 16))
        .padding(.leading, 16)

      Spacer()

      Group {
        if let content { content }
        else {
          Rectangle()
            .fill(Color(.white))
        }
      }
      .frame(maxWidth: .infinity, alignment: .trailing)
    }
    .frame(height: 68)
    .frame(maxWidth: .infinity)
    .bottomBorder()
  }
}
