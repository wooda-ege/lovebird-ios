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

struct CalendarCore: ReducerProtocol {
  
  struct State: Equatable {
    @PresentationState var scheduleAdd: ScheduleAddState?
    @PresentationState var scheduleDetail: ScheduleDetailState?
    // Key는 "0000-00-00" 포맷이다.
    var schedules = [String: [Schedule]]()
    var schedulesOfDay = [Schedule]()
    var currentDate = Date()
    var currentPreviewDate = Date()
    var showCalendarPreview = false
  }
  
  enum Action: Equatable {
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

    // Network
    case loadData
    case dataLoaded(TaskResult<Schedules>)
  }

  @Dependency(\.apiClient) var apiClient

  var body: some ReducerProtocolOf<Self> {
    Reduce { state, action in
      switch action {
      case .plusTapped:
        state.scheduleAdd = ScheduleAddState(date: state.currentDate)
      case .toggleTapped:
        state.currentPreviewDate = state.currentDate
        state.showCalendarPreview = true
      case .dayTapped(let date):
        state.currentDate = date
        state.schedulesOfDay = state.schedules[date.to(dateFormat: Date.Format.YMDDivided)] ?? []
        state.showCalendarPreview = false
      case .previewDayTapped(let date):
        return .send(.dayTapped(date))
      case .scheduleAdd(.presented(.backButtonTapped)):
        state.scheduleAdd = nil
      case .scheduleDetail(.presented(.backButtonTapped)):
        state.scheduleDetail = nil
      case .previewFollowingTapped:
        state.currentPreviewDate = state.currentPreviewDate.addMonths(by: -1)
      case .previewNextTapped:
        state.currentPreviewDate = state.currentPreviewDate.addMonths(by: 1)
      case .scheduleTapped(let schedule):
        state.scheduleDetail = ScheduleDetailState(schedule: schedule)
        state.showCalendarPreview = false
      case .hideCalendarPreview:
        state.showCalendarPreview = false

        // MARK: - Network
      case .loadData:
        return .task {
          .dataLoaded(
            await TaskResult {
              try await (self.apiClient.request(.fetchCalendars) as Schedules)
            }
          )
        }
      case .dataLoaded(.success(let schedules)):
        state.schedules = schedules.schedules.mapToDict()
        return .send(.dayTapped(Date()))
      case .scheduleAdd(.presented(.addScheduleResponse(.success))):
        state.scheduleAdd = nil
      case .scheduleDetail(.presented(.deleteScheduleResponse(.success))):
        state.scheduleDetail = nil
      default:
        break
      }
      return .none
    }
    .ifLet(\.$scheduleAdd, action: /CalendarAction.scheduleAdd) {
      ScheduleAddCore()
    }
    .ifLet(\.$scheduleDetail, action: /CalendarAction.scheduleDetail) {
      ScheduleDetailCore()
    }
  }
}
