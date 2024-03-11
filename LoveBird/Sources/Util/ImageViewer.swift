//
//  ImageViewer.swift
//  LoveBird
//
//  Created by 황득연 on 12/24/23.
//

import SwiftUI
import Kingfisher

struct ImageViewer: View {
  let urlString: String
  @Binding var isShown: Bool

  var body: some View {
    Group {
      if isShown {
        ZStack(alignment: .topTrailing) {
          VStack {
            KFImage(urlString: urlString)
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(maxWidth: .infinity, maxHeight: .infinity)
          }
          .background(.black)

          Button { isShown = false } label: {
            Image(systemName: "xmark")
              .changeSize(to: .init(width: 20, height: 20))
              .foregroundStyle(Color.white)
              .padding([.top, .trailing], 15)
          }
        }
      } else {
        EmptyView()
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}
