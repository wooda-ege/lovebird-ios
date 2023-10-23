//
//  DiaryPreviewContentView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/08/18.
//

import ComposableArchitecture
import SwiftUI

struct DiaryPreviewContentView: View {
  let store: StoreOf<DiaryCore>

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack(alignment: .center, spacing: 0) {
        let numberOfWeeks = viewStore.date.numberOfWeeksInMonth

        ForEach(0..<numberOfWeeks, id: \.self) { week in
          HStack(alignment: .center, spacing: 0) {
            ForEach(1..<8) { weekday in
              let date = self.dateString(currentDate: viewStore.date, week: week, weekday: weekday)

              VStack(alignment: .center) {
                HStack(alignment: .center) {
                  Text(date.isThisMonth ? String(date.date.day) : "")
                    .foregroundColor(.black)
                    .font(.pretendard(
                      size: 12,
                      weight: date.date == viewStore.date ? .bold : .regular
                    ))
                    .frame(width: 32, height: 32, alignment: .center)
                    .background(self.dayBackground(
                      viewStore: viewStore,
                      date: date.date,
                      currentDate: viewStore.state.date
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
    viewStore: ViewStore<DiaryState, DiaryAction>,
    date: Date,
    currentDate: Date
  ) -> some View {
    Group {
      if date == viewStore.date, date.month == currentDate.month {
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

struct DiaryPreviewContentView_Previews: PreviewProvider {
    static var previews: some View {
      DiaryPreviewContentView(
          store: Store(
            initialState: DiaryState(),
            reducer: DiaryCore()
          )
        )
    }
}
