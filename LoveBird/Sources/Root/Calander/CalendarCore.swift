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
    var today = Date()
    var currentDate = Date()
    var isScheduleAddActive = false
  }
  
  enum Action: Equatable {
    case scheduleAdd(PresentationAction<ScheduleAddAction>)
    case plusTapped
    case dayTapped(Date)
    case popScheduleAdd
  }
  
  var body: some ReducerProtocolOf<Self> {
    Reduce { state, action in
      switch action {
      case .plusTapped:
        state.scheduleAdd = ScheduleAddState()
      case .dayTapped(let date):
        state.currentDate = date
      case .scheduleAdd(.presented(.confirmTapped)):
        state.scheduleAdd = nil
      case .scheduleAdd(.presented(.backButtonTapped)):
        state.scheduleAdd = nil
//        return .send(.popScheduleAdd)
//      case .popScheduleAdd:
//        if !state.isScheduleAddActive { return .none}
//        state.scheduleAdd = nil
//        state.isScheduleAddActive = false
      default:
        break
      }
      return .none
    }
    .ifLet(\.$scheduleAdd, action: /CalendarAction.scheduleAdd) {
      ScheduleAddCore()
    }
  }
}
