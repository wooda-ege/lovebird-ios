//
//  CommonToolBar.swift
//  LoveBird
//
//  Created by 황득연 on 2023/06/30.
//

import ComposableArchitecture
import SwiftUI

struct CommonToolBar<Content: View>: View {

  let title: String
  let content: Content?
  let backButtonTapped: () -> Void

  init(title: String, backButtonTapped: @escaping () -> Void, @ViewBuilder content: () -> Content?) {
    self.title = title
    self.backButtonTapped = backButtonTapped
    self.content = content()
  }

  var body: some View {
    HStack(alignment: .center) {
      Button(action: self.backButtonTapped, label: {
        Image(R.image.ic_back)
          .resizable()
          .frame(width: 24, height: 24)
      })
      .frame(maxWidth: .infinity, alignment: .leading)

      Spacer()

      Text(self.title)
        .foregroundColor(.black)
        .font(.pretendard(size: 18, weight: .bold))
        .frame(maxWidth: .infinity)

      Spacer()

      if self.content == nil {
        EmptyView()
      } else {
        self.content
          .frame(maxWidth: .infinity, alignment: .trailing)
      }
    }
    .frame(height: 44)
    .frame(maxWidth: .infinity)
    .padding(.horizontal, 16)
  }
}

//struct CommonToolBar_Previews: PreviewProvider {
//  static var previews: some View {
//    CommonToolBar()
//  }
//}
