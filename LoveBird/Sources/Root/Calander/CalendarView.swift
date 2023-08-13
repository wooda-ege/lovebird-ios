//
//  CalendarView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/28.
//

import ComposableArchitecture
import SwiftUI

struct CalendarView: View {
  let store: StoreOf<CalendarCore>

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      ZStack(alignment: .topLeading) {
        VStack(spacing: 16) {
          CalendarTabView(store: self.store)

          CalendarContentView(store: self.store)
        }
        .onTapGesture {
          viewStore.send(.hideCalendarPreview)
        }

        if viewStore.state.showCalendarPreview {
          VStack {
            CalendarPreviewTabView(viewStore: viewStore)

            CalendarPreviewContentView(store: self.store)
          }
          .padding([.horizontal, .top], 12)
          .padding(.bottom, 20)
          .background(.white)
          .cornerRadius(12)
          .shadow(color: .black.opacity(0.16), radius: 8, x: 0, y: 4)
          .offset(x: 16, y: 44)
        }
      }
      .onAppear {
        viewStore.send(.loadData)
      }
    }
  }
}

//struct CalanderView_Previews: PreviewProvider {
//    static var previews: some View {
//        CalanderView()
//    }
//}
