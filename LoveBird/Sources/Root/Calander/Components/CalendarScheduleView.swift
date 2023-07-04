//
//  CalendarScheduleView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/06/30.
//

import ComposableArchitecture
import SwiftUI

struct CalendarScheduleView: View {

  let viewStore: ViewStore<CalendarState, CalendarAction>

  var body: some View {
    HStack {
      Text("\(self.viewStore.currentDate.month)월 \(self.viewStore.currentDate.day)일")
        .font(.pretendard(size: 14, weight: .bold))
        .foregroundColor(.black)

      Spacer()
    }
    .padding(.top, 24)

    Spacer(minLength: 12)

    VStack(alignment: .center, spacing: 8) {
      Text("일정 없음")
        .font(.pretendard(size: 16))
        .multilineTextAlignment(.center)
        .foregroundColor(Color(R.color.gray05))
        .frame(width: 156, height: 40, alignment: .center)
    }
    .padding(.vertical, 16)
    .frame(width: UIScreen.width - 32, alignment: .center)
    .background(Color(R.color.gray03))
    .cornerRadius(12)
  }
}

//struct CalendarScheduleView_Previews: PreviewProvider {
//  static var previews: some View {
//    CalendarScheduleView()
//  }
//}
