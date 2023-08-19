//
//  CalendarScrollView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/06/30.
//

import ComposableArchitecture
import SwiftUI

struct CalendarContentView: View {
  let store: StoreOf<CalendarCore>

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      GeometryReader { geometry in
        ScrollView(.vertical) {
          VStack(spacing: 0) {
            CalendarWeekdayView(viewStore: viewStore)

            CalendarDateView(viewStore: viewStore)

            CalendarScheduleView(store: self.store)
          }
          .padding(.horizontal, 16)
        }
        .frame(width: geometry.size.width)
        .frame(maxHeight: .infinity)
      }
    }
  }
}

//struct CalendarScrollView_Previews: PreviewProvider {
//  static var previews: some View {
//    CalendarScrollView()
//  }
//}
