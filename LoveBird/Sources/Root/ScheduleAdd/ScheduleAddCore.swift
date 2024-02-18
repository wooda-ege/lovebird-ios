//
//  ScheduleAddCore.swift
//  LoveBird
//
//  Created by 황득연 on 2023/06/30.
//

import Foundation
import ComposableArchitecture

typealias ScheduleAddState = ScheduleAddCore.State
typealias ScheduleAddAction = ScheduleAddCore.Action

struct ScheduleAddCore: Reducer {
  struct State: Equatable {
    
    init(date: Date) {
      idForEditing = nil
      startDate = date
    }
    
    init(schedule: Schedule) {
      idForEditing = schedule.id
      title = schedule.title
      memo = schedule.memo ?? ""
      color = schedule.color
      startDate = schedule.startDate.toDate()
      
      endDate = schedule.endDate != nil
      ? schedule.endDate!.toDate()
      : schedule.startDate.toDate().addDays(by: 1)
      isEndDateActive = schedule.endDate != nil
      
      isTimeActive = schedule.startTime != nil
      if let startTime = schedule.startTime , let endTime = schedule.endTime {
        self.startTime = startTime.toTime()
        self.endTime = endTime.toTime()
      }
    }
    
    let idForEditing: Int?
    var title = ""
    var color: ScheduleColor = .secondary
    var startDate = Date()
    var endDate = Date().addDays(by: 1)
    var startTime = ScheduleTime(hour: 2, minute: 0, meridiem: .pm)
    var endTime = ScheduleTime(hour: 8, minute: 0, meridiem: .pm)
    var alarmBefore = 0
    var memo = ""
    var isEndDateActive = false
    var isTimeActive = false
    var isAlarmActive = false
    var focusedType: ScheduleAddFocusedType = .title
    var alarm: ScheduleAlarm = .typeD
    
    // Bottom Sheet
    var showColorBottomSheet = false
    var showDateBottomSheet = false
    var showTimeBottomSheet = false
    var showAlarmBottomSheet = false
    var year = Date().year
    var month = Date().month
    var day = Date().day
    var time = ScheduleTime(hour: 2, minute: 0, meridiem: .pm)
  }
  
  
  enum Action: Equatable {
    case titleEdited(String)
    case memoEdited(String)
    case backTapped
    case confirmTapped
    case contentTapped(ScheduleAddFocusedType)
    case fisrtDateTapped
    case endDateToggleTapped
    case timeToggleTapped
    case alarmToggleTapped
    case alarmOptionTapped

    // delegate
    case delegate(Delegate)
    enum Delegate {
      case editTapped
    }
    
    // BottomSheet
    case dateInitialied
    case timeInitialied
    case hideColorBottomSheet
    case hideDateBottomSheet
    case hideTimeBottomSheet
    case hideAlarmBottomSheet
    case colorSelected(ScheduleColor)
    case yearSelected(Int)
    case monthSelected(Int)
    case daySelected(Int)
    case hourSelected(Int)
    case minuteSelected(Int)
    case alarmSelected(ScheduleAlarm)
    case meridiemSelected(ScheduleTime.Meridiem)
    
    // Network
    case addScheduleResponse(TaskResult<Empty>)
    case editScheduleResponse(TaskResult<Empty>)
  }
  
  @Dependency(\.lovebirdApi) var lovebirdApi

  @Dependency(\.dismiss) var dismiss

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .contentTapped(let type):
        handleContentTapped(state: &state, type: type)
        return .none
        
      case .endDateToggleTapped:
        state.isEndDateActive = !state.isEndDateActive
        if state.isEndDateActive {
          state.endDate = state.startDate.addDays(by: 1)
        } else {
          state.showDateBottomSheet = false
        }
        return .none
        
      case .timeToggleTapped:
        state.isTimeActive = !state.isTimeActive
        return .none
        
      case .alarmToggleTapped:
        state.isAlarmActive = !state.isAlarmActive
        return .none
        
      case .alarmOptionTapped:
        state.showAlarmBottomSheet = true
        return .none
        
      case .titleEdited(let title):
        state.title = title
        return .none
        
      case .memoEdited(let memo):
        state.memo = memo
        return .none
        
      case .colorSelected(let color):
        state.color = color
        state.showColorBottomSheet = false
        return .none
        
      case .alarmSelected(let alarm):
        state.alarm = alarm
        state.showAlarmBottomSheet = false
        return .none
        
      case .yearSelected(let year):
        state.year = year
        switch state.focusedType {
        case .startDate:
          state.startDate = Date.with(year: year, month: state.month, day: state.day)
          if state.startDate.isLater(than: state.endDate) {
            state.endDate = state.startDate.addDays(by: 1)
          }
          return .none
          
        case .endDate:
          state.endDate = Date.with(year: year, month: state.month, day: state.day)
          if state.startDate.isLater(than: state.endDate) {
            state.startDate = state.endDate.addDays(by: -1)
          }
          return .none
          
        default:
          return .none
        }
        
      case .monthSelected(let month):
        state.month = month
        switch state.focusedType {
        case .startDate:
          state.startDate = Date.with(year: state.year, month: month, day: state.day)
          if state.startDate.isLater(than: state.endDate) {
            state.endDate = state.startDate.addDays(by: 1)
          }
          return .none
          
        case .endDate:
          state.endDate = Date.with(year: state.year, month: month, day: state.day)
          if state.startDate.isLater(than: state.endDate) {
            state.startDate = state.endDate.addDays(by: -1)
          }
          return .none
          
        default:
          return .none
        }
        
      case .daySelected(let day):
        state.day = day
        switch state.focusedType {
        case .startDate:
          state.startDate = Date.with(year: state.year, month: state.month, day: day)
          if state.startDate.isLater(than: state.endDate) {
            state.endDate = state.startDate.addDays(by: 1)
          }
          return .none
          
        case .endDate:
          state.endDate = Date.with(year: state.year, month: state.month, day: day)
          if state.startDate.isLater(than: state.endDate) {
            state.startDate = state.endDate.addDays(by: -1)
          }
          return .none
          
        default:
          return .none
        }
        
      case .hourSelected(let hour):
        state.time.hour = hour
        switch state.focusedType {
        case .startTime:
          state.startTime.hour = hour
          if state.startTime.isLater(than: state.endTime) {
            state.endTime = state.startTime.addOneHour()
          }
          return .none
          
        case .endTime:
          state.endTime.hour = hour
          if state.startTime.isLater(than: state.endTime) {
            state.startTime = state.endTime.subtractOneHour()
          }
          return .none
          
        default:
          return .none
        }
        
      case .minuteSelected(let minute):
        state.time.minute = minute
        switch state.focusedType {
        case .startTime:
          state.startTime.minute = minute
          if state.startTime.isLater(than: state.endTime) {
            state.endTime = state.startTime.addOneHour()
          }
          return .none
          
        case .endTime:
          state.endTime.minute = minute
          if state.startTime.isLater(than: state.endTime) {
            state.startTime = state.endTime.subtractOneHour()
          }
          return .none
          
        default:
          return .none
        }
        
      case .meridiemSelected(let meridiem):
        state.time.meridiem = meridiem
        switch state.focusedType {
        case .startTime:
          state.startTime.meridiem = meridiem
          if state.startTime.isLater(than: state.endTime) {
            state.endTime = state.startTime.addOneHour()
          }
          return .none
          
        case .endTime:
          state.endTime.meridiem = meridiem
          if state.startTime.isLater(than: state.endTime) {
            state.startTime = state.endTime.subtractOneHour()
          }
          return .none
          
        default:
          return .none
        }
        
      case .hideColorBottomSheet:
        state.showColorBottomSheet = false
        return .none
        
      case .hideDateBottomSheet:
        state.showDateBottomSheet = false
        return .none
        
      case .hideTimeBottomSheet:
        state.showTimeBottomSheet = false
        return .none
        
      case .hideAlarmBottomSheet:
        state.showAlarmBottomSheet = false
        return .none
        
      case .dateInitialied:
        handleDateInitialized(state: &state)
        return .none
        
      case .timeInitialied:
        handleTimeInitialized(state: &state)
        return .none

      case .backTapped:
        return .run { _ in await dismiss() }

      case .confirmTapped:
        if state.title.isEmpty { return .none }
        return .runWithLoading { [state] send in
          let schedule = addScheduleRequest(state: state)
          if let id = state.idForEditing {
            await send(
              .editScheduleResponse(
                await TaskResult {
                  try await lovebirdApi.editSchedule(id: id, schedule: schedule)
                }
              )
            )
          } else {
            await send(
              .addScheduleResponse(
                await TaskResult {
                  try await lovebirdApi.addSchedule(schedule: schedule)
                }
              )
            )
          }
        }

        // Network
      case .addScheduleResponse(.success):
        return .run { _ in await dismiss() }

      case let .addScheduleResponse(.failure(error)):
        print("AddSchedule Error: \(error)")
        return .none

      case .editScheduleResponse(.success):
        return .run { _ in await dismiss() }

      case let .editScheduleResponse(.failure(error)):
        print("EditSchedule Error: \(error)")
        return .none

      default:
        return .none
      }
    }
  }

  // MARK: - Methods

  private func initializeDate(state: inout State, date: Date) {
    state.year = date.year
    state.month = date.month
    state.day = date.day
  }

  private func handleContentTapped(state: inout State, type: ScheduleAddFocusedType) {
    state.focusedType = type
    state.showColorBottomSheet = type == .color
    state.showDateBottomSheet = type == .startDate || (type == .endDate && state.isEndDateActive)
    state.showTimeBottomSheet = type == .startTime || type == .endTime
    if type != .alarm {
      state.showAlarmBottomSheet = false
    }
    
    if type == .startDate || type == .endDate {
      var date: Date
      if type == .startDate { date = state.startDate }
      else { date = state.endDate }
      initializeDate(state: &state, date: date)
    }
    
    if type == .startTime || type == .endTime {
      if type == .startTime { state.time = state.startTime }
      else { state.time = state.endTime }
    }
  }
  
  private func handleDateInitialized(state: inout State) {
    switch state.focusedType {
    case .startDate:
      state.startDate = Date()
      initializeDate(state: &state, date: state.startDate)
      if state.startDate.isLater(than: state.endDate) {
        state.endDate = state.startDate.addDays(by: 1)
      }
    case .endDate:
      state.endDate = state.startDate.addDays(by: 1)
      initializeDate(state: &state, date: state.endDate)
      if state.startTime.isLater(than: state.endTime) {
        state.startDate = state.endDate.addDays(by: -1)
      }
    default:
      break
    }
  }

  private func handleTimeInitialized(state: inout State) {
    switch state.focusedType {
    case .startTime:
      state.startTime = ScheduleTime(hour: 2, minute: 0, meridiem: .pm)
      state.time = state.startTime
      if state.startTime.isLater(than: state.endTime) {
        state.endTime = state.startTime.addOneHour()
      }
    case .endTime:
      state.endTime = ScheduleTime(hour: 8, minute: 0, meridiem: .pm)
      state.time = state.endTime
      if state.startTime.isLater(than: state.endTime) {
        state.startTime = state.endTime.subtractOneHour()
      }
    default:
      break
    }
  }

  // MARK: - Getters

  private func addScheduleRequest(state: State) -> AddScheduleRequest {
    return AddScheduleRequest(
      title: state.title,
      memo: state.memo.isEmpty ? nil : state.memo,
      color: state.color,
      alarm: state.isAlarmActive ? state.alarm : nil,
      startDate: state.startDate.to(format: .YMDDivided),
      endDate: state.isEndDateActive ? state.endDate.to(format: .YMDDivided) : nil,
      startTime: state.isTimeActive ? state.startTime.toHMS() : nil,
      endTime: state.isTimeActive ? state.endTime.toHMS() : nil
    )
  }
}
