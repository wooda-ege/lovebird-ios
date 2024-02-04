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
  let backAction: (() -> Void)?
  let content: Content?


  init(title: String = "", backAction: (() -> Void)? = nil, @ViewBuilder content: (() -> Content)) {
    self.title = title
    self.backAction = backAction
    self.content = content()
  }

  init(title: String = "", backAction: (() -> Void)? = nil) {
    self.title = title
    self.backAction = backAction
    self.content = nil
  }

  var body: some View {
    HStack(alignment: .center) {
      backButtonOrEmpty

      Spacer()

      Text(title)
        .foregroundColor(.black)
        .lineLimit(1)
        .font(.pretendard(size: 18, weight: .bold))
        .frame(maxWidth: .infinity)

      Spacer()

      rightItemView
    }
    .background(.white)
    .frame(height: 44)
    .frame(maxWidth: .infinity)
    .padding(.horizontal, 16)
  }
}

private extension CommonToolBar {
  var backButtonOrEmpty: some View {
    Group {
      if let backAction {
        Button(action: backAction, label: {
          Image(asset: LoveBirdAsset.icBack)
            .resizable()
            .frame(width: 24, height: 24)
        })
      } else {
        Rectangle()
          .fill(.clear)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }

  var rightItemView: some View {
    Group {
      if let content { content } else {
        Rectangle()
          .fill(.clear)
      }
    }
    .frame(maxWidth: .infinity, alignment: .trailing)
  }
}

//struct CommonToolBar_Previews: PreviewProvider {
//  static var previews: some View {
//    CommonToolBar()
//  }
//}
