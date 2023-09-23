//
//  CalendarDateView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/06/30.
//

import ComposableArchitecture
import SwiftUI

struct CalendarDateView: View {
  let store: StoreOf<CalendarCore>

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack(alignment: .center, spacing: 0) {
        let numberOfWeeks = viewStore.currentDate.numberOfWeeksInMonth

        ForEach(0..<numberOfWeeks, id: \.self) { week in
          HStack(alignment: .center, spacing: 0) {
            ForEach(1..<8) { weekday in
              let date = self.dateString(
                currentDate: viewStore.currentDate,
                week: week,
                weekday: weekday
              )

              VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .top) {
                  Text(String(date.date.day))
                    .foregroundColor(self.dayForeground(date: date, currentDate: viewStore.currentDate))
                    .font(
                      .pretendard(
                        size: 12,
                        weight: date.date == viewStore.currentDate 
                          ? .bold
                          : .regular
                      )
                    )
                    .frame(width: 20, height: 20)
                    .background(self.dayBackground(date: date.date, currentDate: viewStore.currentDate))

                  Spacer()
                }

                VStack(spacing: 2) {
                  if date.date.year == Date().year, date.isThisMonth,
                     let schedules = viewStore.state.schedules[date.date.to(dateFormat: Date.Format.YMDDivided)] {
                    ForEach(schedules, id: \.id) { schedule in
                      HStack {
                        Text(schedule.title)
                          .lineLimit(1)
                          .font(.pretendard(size: 9, weight: .bold))
                          .foregroundColor(.white)

                        Spacer()
                      }
                      .padding(.horizontal, 4)
                      .padding(.vertical, 2)
                      .background(schedule.color.color)
                      .cornerRadius(2)
                    }
                  }
                }
                .frame(height: 42, alignment: .top)
                .clipped()
              }
              .padding([.top, .horizontal], 4)
              .frame(minWidth: 0, maxWidth: .infinity, maxHeight: .infinity)
              .background(Color.white)
              .overlay(
                Rectangle()
                  .frame(height: 1)
                  .foregroundColor(Color(R.color.gray03)),
                alignment: .bottom
              )
              .onTapGesture {
                viewStore.send(.dayTapped(date.date))
              }
            }
          }
          .frame(height: 72)
        }
      }
      .onAppear {
        viewStore.send(.fetchSchedules)
      }
    }
  }

  private func dayForeground(date: CalendarDate, currentDate: Date) -> Color {
    if date.isToday, date.date == currentDate { return .white }
    return date.isThisMonth ? .black : .gray
  }

  private func dayBackground(date: Date, currentDate: Date) -> some View {
    Group {
      if date == currentDate {
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

struct CalendarDateView_Previews: PreviewProvider {
    static var previews: some View {
      CalendarDateView(
        store: Store(
          initialState: CalendarState(),
          reducer: CalendarCore()
        )
      )
    }
}
