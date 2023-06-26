//
//  DiarySelectCalenderButton.swift
//  LoveBird
//
//  Created by 이예은 on 2023/06/28.
//

import SwiftUI

struct DiarySelectCalenderButton: View {
  var body: some View {
    Button(action: {
      // 추후:: 버튼이 클릭되었을 때 캘린더뷰로 넘어가기
    }) {
      ZStack(alignment: .leading) {
        RoundedRectangle(cornerRadius: 10)
          .foregroundColor(Color(R.color.gray231))
          .frame(height: 44)
        Text("날짜")
          .foregroundColor(Color(R.color.gray122))
          .padding(.leading, 15)
      }
    }
  }
}
