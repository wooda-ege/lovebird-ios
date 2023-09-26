//
//  CalendarPreviewContentView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/07/16.
//

import ComposableArchitecture
import SwiftUI

struct CalendarPreviewContentView: View {
  let store: StoreOf<CalendarCore>

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack(alignment: .center, spacing: 0) {
        let numberOfWeeks = viewStore.currentPreviewDate.numberOfWeeksInMonth

        ForEach(0..<numberOfWeeks, id: \.self) { week in
          HStack(alignment: .center, spacing: 0) {
            ForEach(1..<8) { weekday in
              let date = self.dateString(currentDate: viewStore.currentPreviewDate, week: week, weekday: weekday)
              
              VStack(alignment: .center) {
                HStack(alignment: .center) {
                  Text(date.isThisMonth ? String(date.date.day) : "")
                    .foregroundColor(.black)
                    .font(.pretendard(
                      size: 12,
                      weight: date.date == viewStore.currentPreviewDate ? .bold : .regular
                    ))
                    .frame(width: 32, height: 32, alignment: .center)
                    .background(self.dayBackground(
                      viewStore: viewStore,
                      date: date.date,
                      currentDate: viewStore.state.currentDate
                    ))
                }
              }
              .onTapGesture {
                viewStore.send(.previewDayTapped(date.date))
              }
            }
          }
        }
      }
    }
  }

  private func dayBackground(
    viewStore: ViewStore<CalendarState, CalendarAction>,
    date: Date,
    currentDate: Date
  ) -> some View {
    Group {
      if date == viewStore.currentPreviewDate, date.month == currentDate.month {
        Circle().stroke(Color(asset: LoveBirdAsset.secondary), lineWidth: 2)
      } else {
        EmptyView()
      }
    }
  }

  private func dateString(currentDate: Date, week: Int, weekday: Int) -> CalendarDate {
    let firstDayOfWeek = currentDate.firstDayOfMonth
    let daysToAdd = week * 7 + weekday - firstDayOfWeek.weekday
    let date = firstDayOfWeek.addDays(by: daysToAdd)
    if date.month == currentDate.month {
      return .current(date: date)
    }
    if date.month == currentDate.previousMonth {
      return .previous(date: date)
    }
    return .following(date: date)
  }
}

struct CalendarPreviewContentView_Previews: PreviewProvider {
    static var previews: some View {
      CalendarPreviewContentView(
        store: Store(
          initialState: CalendarCore.State(),
          reducer: CalendarCore()
        )
      )
    }
}
