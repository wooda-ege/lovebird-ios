//
//  DiarySelectCalenderButton.swift
//  LoveBird
//
//  Created by 이예은 on 2023/06/28.
//

import SwiftUI

struct DiarySelectCalenderButton: View {
  var title: String
  
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 10)
        .foregroundColor(Color(R.color.gray02))
        .background(.white)
        .frame(
          height: 44,
          alignment: .leading
        )
      
      HStack {
        Text(title)
        
        Spacer()
      }
      .padding(.leading, 15)
    }
    .background(Color(R.color.gray02))
  }
}
