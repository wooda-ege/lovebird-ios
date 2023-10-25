//
//  CalanderCore.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/28.
//

import Foundation
import ComposableArchitecture

typealias CalendarState = CalendarCore.State
typealias CalendarAction = CalendarCore.Action

protocol PreviewState: Equatable {
  var currentPreviewDate: Date { get }
}

struct CalendarCore: Reducer {

  // MARK: - State

  struct State: PreviewState {
    @PresentationState var scheduleAdd: ScheduleAddState?
    @PresentationState var scheduleDetail: ScheduleDetailState?
    // Key는 "0000-00-00" 포맷이다.
    var schedules = [String: [Schedule]]()
    var schedulesOfDay = [Schedule]()
    var currentDate = Date()
    var currentPreviewDate = Date()
    var showCalendarPreview = false
  }

  // MARK: - Action
  
  enum Action: Equatable {
    case viewAppear
    case dataLoaded(TaskResult<Schedules>)
    case scheduleAdd(PresentationAction<ScheduleAddAction>)
    case scheduleDetail(PresentationAction<ScheduleDetailAction>)
    case plusTapped
    case toggleTapped
    case dayTapped(Date)
    case previewDayTapped(Date)
    case previewFollowingTapped
    case previewNextTapped
    case fetchSchedules
    case scheduleTapped(Schedule)
    case hideCalendarPreview
  }

  // MARK: - Dependency

  @Dependency(\.apiClient) var apiClient

  // MARK: - Body

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .viewAppear:
				return .run { send in
					await send(
						.dataLoaded(
							await TaskResult {
								try await (self.apiClient.request(.fetchCalendars) as Schedules)
							}
						)
					)
				}

      case .plusTapped:
        state.scheduleAdd = ScheduleAddState(date: state.currentDate)
        return .none

      case .toggleTapped:
        state.currentPreviewDate = state.currentDate
        state.showCalendarPreview = true
        return .none

      case .dayTapped(let date):
        state.currentDate = date
        state.schedulesOfDay = state.schedules[date.to(dateFormat: Date.Format.YMDDivided)] ?? []
        state.showCalendarPreview = false
        return .none

      case .previewDayTapped(let date):
        return .send(.dayTapped(date))

      case .scheduleAdd(.presented(.backButtonTapped)):
        state.scheduleAdd = nil
        return .none

      case .scheduleDetail(.presented(.backButtonTapped)):
        state.scheduleDetail = nil
        return .none

      case .previewFollowingTapped:
        state.currentPreviewDate = state.currentPreviewDate.addMonths(by: -1)
        return .none

      case .previewNextTapped:
        state.currentPreviewDate = state.currentPreviewDate.addMonths(by: 1)
        return .none

      case .scheduleTapped(let schedule):
        state.scheduleDetail = ScheduleDetailState(schedule: schedule)
        state.showCalendarPreview = false
        return .none

      case .hideCalendarPreview:
        state.showCalendarPreview = false
        return .none

      case .dataLoaded(.success(let schedules)):
        state.schedules = schedules.schedules.mapToDict()
        return .send(.dayTapped(Date()))

      case .scheduleAdd(.presented(.addScheduleResponse(.success))):
        state.scheduleAdd = nil
        return .none

      case .scheduleDetail(.presented(.deleteScheduleResponse(.success))):
        state.scheduleDetail = nil
        return .none

      default:
        return .none
      }
    }
    .ifLet(\.$scheduleAdd, action: /CalendarAction.scheduleAdd) {
      ScheduleAddCore()
    }
    .ifLet(\.$scheduleDetail, action: /CalendarAction.scheduleDetail) {
      ScheduleDetailCore()
    }
  }
}
