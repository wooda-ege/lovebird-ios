//
//  CalendarScheduleView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/06/30.
//

import ComposableArchitecture
import SwiftUI

struct CalendarDateView: View {

  let viewStore: ViewStore<CalendarState, CalendarAction>

  var body: some View {
    VStack(alignment: .center, spacing: 0) {
      let weekOfMonth = self.viewStore.currentDate.calculateWeekOfMonth
      ForEach(0..<weekOfMonth, id: \.self) { week in
        HStack(alignment: .center, spacing: 0) {
          ForEach(1..<8) { weekday in
            let date = self.dateString(currentDate: self.viewStore.currentDate, week: week, weekday: weekday)
            VStack(alignment: .leading) {
              HStack(alignment: .top) {
                Text(String(date.date.day))
                  .foregroundColor(self.dayForeground(date: date))
                  .font(.pretendard(
                    size: 12,
                    weight: date.date == self.viewStore.currentDate ? .bold : .regular
                  ))
                  .frame(width: 20, height: 20)
                  .background(self.dayBackground(date: date.date))

                Spacer(minLength: 0)
              }

              Spacer(minLength: 4)

              VStack(spacing: 2) {
                if date.date.year == Date().year, date.isThisMonth, let schedules = self.viewStore.state.schedules[date.date.to(dateFormat: Date.Format.YMDDivided)] {
                  ForEach(schedules, id: \.id) { schedule in
                    VStack(alignment: .center) {
                      Text(schedule.title)
                        .lineLimit(1)
                        .font(.pretendard(size: 9, weight: .bold))
                        .foregroundColor(.white)
                    }
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                    .background(schedule.color.color)
                    .cornerRadius(2)
                  }
                }

                Spacer()
              }
            }
            .padding([.top, .horizontal], 4)
            .frame(minWidth: 0, maxWidth: .infinity)
            .overlay(
              Rectangle()
                .frame(height: 1)
                .foregroundColor(Color(R.color.gray03)),
              alignment: .bottom
            )
            .onTapGesture {
              self.viewStore.send(.dayTapped(date.date))
            }
          }
        }
        .frame(height: 72)
      }
    }
    .onAppear {
      self.viewStore.send(.fetchSchedules)
    }
  }

  private func dayForeground(date: CalendarDate) -> Color {
    if date.isToday, date.date == self.viewStore.currentDate { return .white }
    return date.isThisMonth ? .black : .gray
  }

  private func dayBackground(date: Date) -> some View {
    Group {
      if date == self.viewStore.currentDate {
        if date == Date() {
          Circle().fill(Color(R.color.secondary))
        } else {
          Circle().stroke(Color(R.color.secondary), lineWidth: 2)
        }
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

//struct CalendarScheduleView_Previews: PreviewProvider {
//    static var previews: some View {
//        CalendarScheduleView()
//    }
//}
