//
//  CalendarPreviewContentView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/07/16.
//

import ComposableArchitecture
import SwiftUI

struct CalendarPreviewContentView: View {
  let viewStore: ViewStore<CalendarState, CalendarAction>

  var body: some View {
    VStack(alignment: .center, spacing: 0) {
      let weekOfMonth = self.viewStore.currentPreviewDate.calculateWeekOfMonth
      ForEach(0..<weekOfMonth, id: \.self) { week in
        HStack(alignment: .center, spacing: 0) {
          ForEach(1..<8) { weekday in
            let date = self.dateString(currentDate: self.viewStore.currentPreviewDate, week: week, weekday: weekday)
            VStack(alignment: .center) {
              HStack(alignment: .center) {
                Text(date.isThisMonth ? String(date.date.day) : "")
                  .foregroundColor(.black)
                  .font(.pretendard(
                    size: 12,
                    weight: date.date == self.viewStore.currentPreviewDate ? .bold : .regular
                  ))
                  .frame(width: 32, height: 32, alignment: .center)
                  .background(self.dayBackground(date: date.date, currentDate: self.viewStore.state.currentDate))
              }
            }
            .onTapGesture {
              self.viewStore.send(.previewDayTapped(date.date))
            }
          }
        }
      }
    }
  }

  private func dayBackground(date: Date, currentDate: Date) -> some View {
    Group {
      if date == self.viewStore.currentPreviewDate, date.month == currentDate.month {
        Circle().stroke(Color(R.color.secondary), lineWidth: 2)
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

//struct CalendarPreviewContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        CalendarPreviewContentView()
//    }
//}
