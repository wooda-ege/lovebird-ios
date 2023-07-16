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

  struct State: Equatable {
    @PresentationState var scheduleAdd: ScheduleAddState?
    let schedule: Schedule
  }

  enum Action: Equatable {
    case scheduleAdd(PresentationAction<ScheduleAddAction>)
    case backButtonTapped
    case editTapped
    case deleteTapped
  }

  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .editTapped:
        state.scheduleAdd = ScheduleAddState(schedule: state.schedule)
      default:
        break
      }
      return .none
    }
    .ifLet(\.$scheduleAdd, action: /ScheduleDetailAction.scheduleAdd) {
      ScheduleAddCore()
    }
  }
}
