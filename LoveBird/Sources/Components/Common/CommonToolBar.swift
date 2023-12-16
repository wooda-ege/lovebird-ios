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
  let backAction: () -> Void

  init(backAction: @escaping () -> Void, @ViewBuilder content: () -> Content) {
    self.init(title: "", backAction: backAction, content: content)
  }
  
  init(title: String, backAction: @escaping () -> Void, @ViewBuilder content: () -> Content) {
    self.title = title
    self.backAction = backAction
    self.content = content()
  }

  init(title: String, backAction: @escaping () -> Void) {
    self.title = title
    self.backAction = backAction
    self.content = nil
  }
  
  var body: some View {
    HStack(alignment: .center) {
      Button(action: backAction, label: {
        Image(asset: LoveBirdAsset.icBack)
          .resizable()
          .frame(width: 24, height: 24)
      })
      .frame(maxWidth: .infinity, alignment: .leading)

      Spacer()

      Text(title)
        .foregroundColor(.black)
        .lineLimit(1)
        .font(.pretendard(size: 18, weight: .bold))
        .frame(maxWidth: .infinity)

      Spacer()

      if content == nil {
        Rectangle()
          .fill(Color(.white))
          .frame(maxWidth: .infinity, alignment: .trailing)
      } else {
        content
          .frame(maxWidth: .infinity, alignment: .trailing)
      }
    }
    .background(.white)
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
