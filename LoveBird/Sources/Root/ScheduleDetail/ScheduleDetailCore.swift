//
//  ScheduleDetailCore.swift
//  LoveBird
//
//  Created by 황득연 on 2023/07/04.
//

import Foundation
import ComposableArchitecture

typealias ScheduleDetailState = ScheduleDetailCore.State
typealias ScheduleDetailAction = ScheduleDetailCore.Action

struct ScheduleDetailCore: ReducerProtocol {

  // MARK: - State

  struct State: Equatable {
    @PresentationState var scheduleAdd: ScheduleAddState?
    var schedule: Schedule

    init(schedule: Schedule) {
      self.schedule = schedule
    }
  }

  // MARK: - Action

  enum Action: Equatable {
    case scheduleAdd(PresentationAction<ScheduleAddAction>)
    case backButtonTapped
    case editTapped
    case deleteTapped

    // Network
    case deleteScheduleResponse(TaskResult<String>)
    case fetchScheduleResponse(TaskResult<Schedule>)
  }

  // MARK: - Dependency

  @Dependency(\.apiClient) var apiClient

  // MARK: - Body
  
  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .editTapped:
        state.scheduleAdd = ScheduleAddState(schedule: state.schedule)
        return .none

      case .deleteTapped:
        return .task { [scheduleId = state.schedule.id] in
          .deleteScheduleResponse(
            await TaskResult {
              try await self.apiClient.requestRaw(.deleteSchedule(scheduleId))
            }
          )
        }

      case .scheduleAdd(.presented(.editScheduleResponse(.success))):
        state.scheduleAdd = nil
        return .task { [id = state.schedule.id] in
          .fetchScheduleResponse(
            await TaskResult {
              try await (self.apiClient.request(.fetchSchedule(id: id)) as Schedule)
            }
          )
        }

      case .fetchScheduleResponse(.success(let schedule)):
        state.schedule = schedule
        return .none

      case .scheduleAdd(.presented(.backButtonTapped)):
        state.scheduleAdd = nil
        return .none

      default:
        return .none
      }
    }
    .ifLet(\.$scheduleAdd, action: /ScheduleDetailAction.scheduleAdd) {
      ScheduleAddCore()
    }
  }
}
