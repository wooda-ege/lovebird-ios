//
//  CommonHorizontalButton.swift
//  LoveBird
//
//  Created by 황득연 on 2023/09/14.
//

import SwiftUI

struct CommonHorizontalButton: View {

  let title: String
  let backgroundColor: Color
  let onTap: () -> Void

  init(title: String, backgroundColor: Color = .black, onTap: @escaping () -> Void) {
    self.title = title
    self.backgroundColor = backgroundColor
    self.onTap = onTap
  }

  var body: some View {
    Button { self.onTap() } label: {
      TouchableView {
        Text(self.title)
          .font(.pretendard(size: 16, weight: .semiBold))
          .foregroundColor(.white)
      }
    }
    .frame(height: 56)
    .background(self.backgroundColor)
    .cornerRadius(12)
  }
}

//struct CommonToolBar_Previews: PreviewProvider {
//  static var previews: some View {
//    CommonToolBar()
//  }
//}
