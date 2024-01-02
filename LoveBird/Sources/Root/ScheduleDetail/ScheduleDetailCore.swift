//
//  ScheduleDetailCore.swift
//  LoveBird
//
//  Created by 황득연 on 2023/07/04.
//

import Foundation
import ComposableArchitecture

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
    case deleteSchedule
    case alertButtonTapped(AlertController.Style.`Type`?)

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
  @Dependency(\.alertController) var alertController
  @Dependency(\.toastController) var toastController

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
        alertController.showAlert(type: .deleteSchedule)
        return .publisher {
          alertController.buttonClick
            .map(Action.alertButtonTapped)
        }

      case let .alertButtonTapped(type):
        if let type { return .send(.deleteSchedule) }
        else { return .none }

      case .deleteSchedule:
        return .runWithLoading { [scheduleId = state.schedule.id] send in
          await send(
            .deleteScheduleResponse(
              await TaskResult {
                try await self.lovebirdApi.deleteSchedule(id: scheduleId)
              }
            )
          )
        }

      case .deleteScheduleResponse(.success):
        return .run { _ in
          await toastController.showToast(message: "삭제가 완료됐어요!")
          await dismiss()
        }

      case let .deleteScheduleResponse(.failure(error)):
        print("DeleteSchedule Error: \(error)")
        return .none

      default:
        return .none
      }
    }
  }
}

typealias ScheduleDetailState = ScheduleDetailCore.State
typealias ScheduleDetailAction = ScheduleDetailCore.Action
