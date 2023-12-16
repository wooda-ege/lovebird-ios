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
    var schedule: Schedule

    init(schedule: Schedule) {
      self.schedule = schedule
    }
  }

  // MARK: - Action

  enum Action: Equatable {
    case backTapped
    case editTapped
    case deleteTapped

    // delegate
    case delegate(Delegate)
    enum Delegate: Equatable {
      case goToScheduleAdd(Schedule)
    }

    // Network
    case deleteScheduleResponse(TaskResult<StatusCode>)
    case fetchScheduleResponse(TaskResult<Schedule>)
  }

  // MARK: - Dependency

  @Dependency(\.lovebirdApi) var lovebirdApi
  @Dependency(\.dismiss) var dismiss

  // MARK: - Body
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {

      case .backTapped:
        return .run { _ in await dismiss() }

      case .editTapped:
        return .send(.delegate(.goToScheduleAdd(state.schedule)))

      case .deleteTapped:
				return .run { [scheduleId = state.schedule.id] send in
					await send(
						.deleteScheduleResponse(
							await TaskResult {
                try await self.lovebirdApi.deleteSchedule(id: scheduleId)
							}
						)
					)
				}

      case .deleteScheduleResponse(.success):
        return .run { _ in await dismiss() }

      case let .deleteScheduleResponse(.failure(error)):
        print("DeleteSchedule Error: \(error)")
        return .none

      default:
        return .none
      }
    }
  }
}
