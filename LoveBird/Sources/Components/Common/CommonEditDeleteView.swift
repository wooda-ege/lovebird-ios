//
//  CommonEditDeleteView.swift
//  LoveBird
//
//  Created by 이예은 on 11/9/23.
//

import SwiftUI

struct CommonEditDeleteView: View {
  var body: some View {
    VStack {
      Text("수정하기")
      Divider()
      Text("삭제하기")
    }
    .foregroundColor(.black)
    .frame(width: 120, height: 78)
  }
}
