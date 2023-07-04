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
    var addSchedule: ScheduleAddState?
    var today = Date()
    var currentDate = Date()
    var isScheduleAddActive = false
  }
  
  enum Action: Equatable {
    case scheduleAdd(ScheduleAddAction)
    case plusTapped
    case dayTapped(Date)
    case popScheduleAdd
  }
  
  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .plusTapped:
        state.addSchedule = ScheduleAddState()
        state.isScheduleAddActive = true
      case .dayTapped(let date):
        state.currentDate = date
      case .scheduleAdd(.backButtonTapped):
        return .send(.popScheduleAdd)
      case .popScheduleAdd:
        state.isScheduleAddActive = false
      default:
        break
      }
      return .none
    }
    .ifLet(\.addSchedule, action: /CalendarAction.scheduleAdd) {
      ScheduleAddCore()
    }
  }
}
