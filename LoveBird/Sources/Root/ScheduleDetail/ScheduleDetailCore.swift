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

struct ScheduleDetailCore: Reducer {

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
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .editTapped:
        state.scheduleAdd = ScheduleAddState(schedule: state.schedule)
        return .none

      case .deleteTapped:
				return .run { [scheduleId = state.schedule.id] send in
					await send(
						.deleteScheduleResponse(
							await TaskResult {
								try await self.apiClient.requestRaw(.deleteSchedule(scheduleId))
							}
						)
					)
				}

      case .scheduleAdd(.presented(.editScheduleResponse(.success))):
        state.scheduleAdd = nil
				return .run { [id = state.schedule.id] send in
					await send(
						.fetchScheduleResponse(
							await TaskResult {
								try await (self.apiClient.request(.fetchSchedule(id: id)) as Schedule)
							}
						)
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
