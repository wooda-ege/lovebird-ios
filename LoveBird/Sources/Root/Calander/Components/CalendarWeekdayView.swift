//
//  CalendarScheduleView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/06/30.
//

import ComposableArchitecture
import SwiftUI

struct CalendarWeekdayView: View {
  var body: some View {
    HStack(alignment: .center, spacing: 0) {
      ForEach(DateFormatter.daysOfWeek(), id: \.self) { day in
        Text(day)
          .foregroundColor(day.isWeekend ? Color(asset: LoveBirdAsset.error) : Color(asset: LoveBirdAsset.gray07))
          .font(.pretendard(size: 10, weight: .bold))
          .frame(minWidth: 0, maxWidth: .infinity)
          .frame(height: 20)
          .background(Color(asset: LoveBirdAsset.gray251))
          .overlay(
            Rectangle()
              .frame(height: 1)
              .foregroundColor(Color(asset: LoveBirdAsset.gray03)),
            alignment: .bottom
          )
      }
    }
  }
}

struct CalendarWeekdayView_Previews: PreviewProvider {
  static var previews: some View {
    CalendarWeekdayView()
  }
}
