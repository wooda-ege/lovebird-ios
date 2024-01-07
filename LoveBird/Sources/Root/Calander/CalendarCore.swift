//
//  CalanderCore.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/28.
//

import Foundation
import ComposableArchitecture

protocol PreviewState: Equatable {
  var currentPreviewDate: Date { get }
}

struct CalendarCore: Reducer {

  // MARK: - State

  struct State: PreviewState {
    var monthlys = [CalendarMonthly]()
    var currentMonthly = CalendarMonthly.dummy
    var schedules: CalendarMonthly.Schedules = [:]
    var currentDate = Date()
    var currentPreviewDate = Date()
    var showCalendarPreview = false
  }

  // MARK: - Action

  enum Action: Equatable {
    case viewAppear
    case dataLoaded(TaskResult<[Schedule]>)
    case plusTapped(Date)
    case toggleTapped
    case dayTapped(Date)
    case previewDayTapped(Date)
    case previewFollowingTapped
    case previewNextTapped
    case fetchSchedules
    case scheduleTapped(Schedule)
    case hideCalendarPreview
    case monthlyChanged(CalendarMonthly)
    case none
  }

  // MARK: - Dependency

  @Dependency(\.lovebirdApi) var lovebirdApi

  // MARK: - Body

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .viewAppear:
        return .runWithLoading { send in
          await send(
            .dataLoaded(
              await TaskResult {
                try await lovebirdApi.fetchCalendars()
              }
            )
          )
        }

      case .toggleTapped:
        state.currentPreviewDate = state.currentDate
        state.showCalendarPreview = true
        return .none

      case .dayTapped(let date):
        state.currentDate = date
        let monthlys = initialMonthlys(date: date, schedules: state.schedules)
        state.monthlys = monthlys
        state.currentMonthly = monthlys.center ?? CalendarMonthly.dummy
        return .none

      case .previewDayTapped(let date):
        state.showCalendarPreview = false
        return .send(.dayTapped(date))

      case .previewFollowingTapped:
        state.currentPreviewDate = state.currentPreviewDate.addMonths(by: -1)
        return .none

      case .previewNextTapped:
        state.currentPreviewDate = state.currentPreviewDate.addMonths(by: 1)
        return .none

      case .hideCalendarPreview:
        state.showCalendarPreview = false
        return .none

      case let .monthlyChanged(currentCalendar):
        if let lastCalendar = state.monthlys.last,
           lastCalendar == currentCalendar,
           let lastDate = Date(from: lastCalendar.id) {
          let additaionalMonthlys = additionalFollowingMonthlys(by: 12, date: lastDate, schedules: state.schedules)
          state.monthlys.append(contentsOf: additaionalMonthlys)
        }

        if let firstCalendar = state.monthlys.first,
           firstCalendar == currentCalendar,
           let firstDate = Date(from: firstCalendar.id) {
          let additaionalMonthlys = additionalPreviousMonthlys(by: 12, date: firstDate, schedules: state.schedules)
          state.monthlys.insert(contentsOf: additaionalMonthlys, at: 0)
        }

        state.currentDate = currentCalendar.selectedDate
        state.currentMonthly = currentCalendar
        return .none

      case let .dataLoaded(.success(schedules)):
        let schedules = schedules.mapToDict()
        state.schedules = schedules
        state.monthlys = initialMonthlys(date: Date(), schedules: schedules)
        return .send(.dayTapped(Date()))

      default:
        return .none
      }
    }
  }

  // TODO: Calendar API 수정되면 수정할 것
  private func initialMonthlys(date: Date, schedules: CalendarMonthly.Schedules) -> [CalendarMonthly] {
    var monthlySchedules = [CalendarMonthly]()
    // 앞뒤 각각 2년 기간의 Monthly를 미리 생성해 놓는다.
    for i in -24...24 {
      let dateAdded = i == 0 ? date : date.addMonths(by: i).firstDayOfMonth
      monthlySchedules.append(
        .init(
          id: dateAdded.to(format: .YMDivided),
          selectedDate: dateAdded,
          dailySchedules: schedules[dateAdded.to(format: .YMDDivided)] ?? []
        )
      )
    }
    return monthlySchedules
  }

  private func additionalPreviousMonthlys(
    by count: Int,
    date: Date,
    schedules: CalendarMonthly.Schedules
  ) -> [CalendarMonthly] {
    var monthlySchedules = [CalendarMonthly]()
    for i in -count..<0 {
      let dateAdded = date.addMonths(by: i).firstDayOfMonth
      monthlySchedules.append(
        .init(
          id: dateAdded.to(format: .YMDivided),
          selectedDate: dateAdded,
          dailySchedules: schedules[dateAdded.to(format: .YMDDivided)] ?? []
        )
      )
    }
    return monthlySchedules
  }

  private func additionalFollowingMonthlys(
    by count: Int,
    date: Date,
    schedules: CalendarMonthly.Schedules
  ) -> [CalendarMonthly] {
    var monthlySchedules = [CalendarMonthly]()
    for i in 1...count {
      let dateAdded = date.addMonths(by: i).firstDayOfMonth
      monthlySchedules.append(
        .init(
          id: dateAdded.to(format: .YMDivided),
          selectedDate: dateAdded,
          dailySchedules: schedules[dateAdded.to(format: .YMDDivided)] ?? []
        )
      )
    }
    return monthlySchedules
  }
}

typealias CalendarState = CalendarCore.State
typealias CalendarAction = CalendarCore.Action
