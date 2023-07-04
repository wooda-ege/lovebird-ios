//
//  CalendarScrollView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/06/30.
//

import ComposableArchitecture
import SwiftUI

struct CalendarContentView: View {

  let viewStore: ViewStore<CalendarState, CalendarAction>

  var body: some View {
    GeometryReader { geometry in
      ScrollView(.vertical) {
        VStack(spacing: 0) {
          CalendarWeekdayView(viewStore: self.viewStore)

          CalendarDateView(viewStore: self.viewStore)

          CalendarScheduleView(viewStore: self.viewStore)
        }
        .padding(.horizontal, 16)
      }
      .frame(width: geometry.size.width)
      .frame(maxHeight: .infinity)
    }
  }
}

//struct CalendarScrollView_Previews: PreviewProvider {
//  static var previews: some View {
//    CalendarScrollView()
//  }
//}
