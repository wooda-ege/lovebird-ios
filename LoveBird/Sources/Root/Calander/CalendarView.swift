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
    WithViewStore(store, observe: { $0 }) { viewStore in
      ZStack(alignment: .topLeading) {
        VStack(spacing: 16) {
          toolbarView
          contentView
        }

        if viewStore.state.showCalendarPreview {
          previewView
        }
      }
      .onAppear {
        viewStore.send(.viewAppear)
      }
    }
  }

  private func calendarDate(currentDate: Date, week: Int, weekday: Int) -> CalendarDate {
    let firstDayOfWeek = currentDate.firstDayOfMonth
    let daysToAdd = week * 7 + weekday - firstDayOfWeek.weekday
    let date = firstDayOfWeek.addDays(by: daysToAdd)
    return if date.month == currentDate.month { .current(date: date) }
    else if date.month == currentDate.previousMonth { .previous(date: date) }
    else { .following(date: date) }
  }

  private func dayForeground(date: CalendarDate, currentDate: Date) -> Color {
    if date.isToday, date.date == currentDate { return .white }
    return date.isThisMonth ? .black : Color.init(asset: LoveBirdAsset.gray04)
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

  private func dayBackground(date: Date, currentDate: Date) -> some View {
    Group {
      if date == currentDate {
        if date == Date() {
          Circle().fill(Color(asset: LoveBirdAsset.secondary))
        } else {
          Circle().stroke(Color(asset: LoveBirdAsset.secondary), lineWidth: 2)
        }
      } else {
        EmptyView()
      }
    }
  }
}

extension CalendarView {
  var toolbarView: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      TouchableStack {
        HStack(alignment: .center) {
          HStack(spacing: 0) {
            Text(String(viewStore.currentMonthly.id.year) + "." + String(viewStore.currentMonthly.id.month))
              .font(.pretendard(size: 22, weight: .bold))
              .foregroundColor(.black)

            Image(asset: LoveBirdAsset.icArrowDropDown)
              .frame(width: 24, height: 24)
          }
          .onTapGesture {
            viewStore.send(.toggleTapped)
          }

          Spacer()

          HStack(spacing: 16) {
            Button { viewStore.send(.plusTapped(viewStore.currentDate)) } label: {
              Image(asset: LoveBirdAsset.icPlus)
            }
          }
        }
        .frame(height: 44)
        .padding(.horizontal, 16)
      }
    }
  }

  var contentView: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      GeometryReader { geometry in
        TabView(selection: viewStore.binding(get: \.currentMonthly, send: CalendarAction.monthlyChanged)) {
          ForEach(viewStore.monthlys, id: \.id) { monthly in
            ScrollView(.vertical) {
              VStack(spacing: 0) {
                weekdayView
                dateView(monthly: monthly)
                scheduleView(monthly: monthly)
              }
              .padding(.horizontal, 16)
            }
            .tag(monthly)
            .frame(width: geometry.size.width)
            .frame(maxHeight: .infinity)
          }
        }
        .tabViewStyle(.page)
      }
    }
  }

  var weekdayView: some View {
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

  func dateView(monthly: CalendarMonthly) -> some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(alignment: .center, spacing: 0) {
        let numberOfWeeks = monthly.selectedDate.numberOfWeeksInMonth

        ForEach(0..<numberOfWeeks, id: \.self) { week in
          HStack(alignment: .center, spacing: 0) {
            ForEach(1..<8) { weekday in
              let date = calendarDate(
                currentDate: monthly.selectedDate,
                week: week,
                weekday: weekday
              )

              VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .top) {
                  Text(String(date.date.day))
                    .foregroundColor(dayForeground(date: date, currentDate: monthly.selectedDate))
                    .font(
                      .pretendard(
                        size: 12,
                        weight: date.date == monthly.selectedDate ? .bold : .regular
                      )
                    )
                    .frame(width: 20, height: 20)
                    .background(
                      Group {
                        if date.date == monthly.selectedDate {
                          if date.date.isToday {
                            Circle().fill(Color(asset: LoveBirdAsset.secondary))
                          } else {
                            Circle().stroke(Color(asset: LoveBirdAsset.secondary), lineWidth: 2)
                          }
                        } else {
                          EmptyView()
                        }
                      }
                    )

                  Spacer()
                }

                VStack(spacing: 2) {
                  if let schedules = viewStore.state.schedules[date.date.to(format: .YMDDivided)] {
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
                      .background(date.isThisMonth ? schedule.color.color : schedule.color.color.opacity(0.2))
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
                  .foregroundColor(Color(asset: LoveBirdAsset.gray03)),
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

  func scheduleView(monthly: CalendarMonthly) -> some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      HStack {
        Text("\(monthly.selectedDate.month)월 \(monthly.selectedDate.day)일")
          .font(.pretendard(size: 14, weight: .bold))
          .foregroundColor(.black)

        Spacer()
      }
      .padding(.top, 24)

      Spacer(minLength: 12)

      VStack(alignment: .center, spacing: 8) {
        if monthly.dailySchedules.isEmpty {
          Text("일정 없음")
            .font(.pretendard(size: 16))
            .multilineTextAlignment(.center)
            .foregroundColor(Color(asset: LoveBirdAsset.gray05))
            .frame(maxWidth: .infinity)
            .frame(height: 40, alignment: .center)
        } else {
          ForEach(monthly.dailySchedules, id: \.id) { schedule in
            Button { viewStore.send(.scheduleTapped(schedule)) } label: {
              HStack(alignment: .center, spacing: 4) {
                Rectangle()
                  .fill(schedule.color.color)
                  .frame(width: 2)
                  .frame(maxHeight: .infinity)
                  .cornerRadius(1)

                Text(schedule.title)
                  .font(.pretendard(size: 14))
                  .foregroundColor(.black)
                  .padding(.horizontal, 16)
                  .padding(.vertical, 12)
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .background(.white)
                  .cornerRadius(8)
              }
            }
          }
        }
      }
      .padding([.top, .horizontal], 16)
      .padding(.bottom, monthly.dailySchedules.count == 2 ? 8 : 16)
      .background(Color(asset: LoveBirdAsset.gray03))
      .cornerRadius(12)
    }
  }

  var previewView: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ZStack(alignment: .topLeading) {
        Rectangle()
          .fill(Color.touchable)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .onTouch {
            viewStore.send(.hideCalendarPreview)
          }

        VStack {
          previewWeekdayView
          previewDateView
        }
        .padding([.horizontal, .top], 12)
        .padding(.bottom, 20)
        .background(.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.16), radius: 8, x: 0, y: 4)
        .offset(x: 16, y: 44)
      }
    }
  }

  var previewWeekdayView: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      HStack(alignment: .center) {
        Button {
          viewStore.send(.previewFollowingTapped)
        } label: {
          Image(asset: LoveBirdAsset.icNavigatePreviousActive)
            .changeColor(to: Color(asset: LoveBirdAsset.gray08))
            .changeSize(to: .init(width: 44, height: 44))
        }

        Spacer()

        Text(String(viewStore.currentPreviewDate.year) + "." + String(viewStore.currentPreviewDate.month))
          .font(.pretendard(size: 16, weight: .bold))
          .foregroundColor(.black)

        Spacer()

        Button {
          viewStore.send(.previewNextTapped)
        } label: {
          Image(asset: LoveBirdAsset.icNavigateNextActive)
            .changeColor(to: Color(asset: LoveBirdAsset.gray08))
            .changeSize(to: .init(width: 44, height: 44))
        }
      }
      .padding(8)
      .frame(width: 237, alignment: .center)
      .background(Color(asset: LoveBirdAsset.gray03))
      .cornerRadius(12)
    }
  }

  var previewDateView: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(alignment: .center, spacing: 0) {
        let numberOfWeeks = viewStore.currentPreviewDate.numberOfWeeksInMonth

        ForEach(0..<numberOfWeeks, id: \.self) { week in
          HStack(alignment: .center, spacing: 0) {
            ForEach(1..<8) { weekday in
              let date = calendarDate(currentDate: viewStore.currentPreviewDate, week: week, weekday: weekday)
              let isHighlighted = date.date == viewStore.currentPreviewDate && date.date.month == viewStore.currentDate.month

              VStack(alignment: .center) {
                HStack(alignment: .center) {
                  Text(date.isThisMonth ? String(date.date.day) : "")
                    .foregroundColor(.black)
                    .font(.pretendard(
                      size: 12,
                      weight: isHighlighted ? .bold : .regular
                    ))
                    .frame(width: 32, height: 32, alignment: .center)
                    .background(
                      Group {
                        if isHighlighted { Circle().stroke(Color(asset: LoveBirdAsset.secondary), lineWidth: 2) }
                        else { EmptyView() }
                      }
                    )
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
}

#Preview {
  CalendarView(
    store: Store(
      initialState: CalendarState(),
      reducer: { CalendarCore() }
    )
  )
}
