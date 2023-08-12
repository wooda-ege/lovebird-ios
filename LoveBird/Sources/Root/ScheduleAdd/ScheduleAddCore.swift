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

struct ScheduleAddCore: ReducerProtocol {
  struct State: Equatable {

    init(date: Date) {
      self.idForEditing = nil
      self.startDate = date
    }

    init(schedule: Schedule) {
      self.idForEditing = schedule.id
      self.title = schedule.title
      self.memo = schedule.memo ?? ""
      self.color = schedule.color
      self.startDate = schedule.startDate.toDate()

      self.endDate = schedule.endDate != nil
        ? schedule.endDate!.toDate()
        : schedule.startDate.toDate().addDays(by: 1)
      self.isEndDateActive = schedule.endDate != nil

      self.isTimeActive = schedule.startTime != nil
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

    // ScheduleDetail
    @PresentationState var scheduleDetail: ScheduleDetailState?
  }


  enum Action: Equatable {
    case titleEdited(String)
    case memoEdited(String)
    case backButtonTapped
    case confirmTapped
    case contentTapped(ScheduleAddFocusedType)
    case fisrtDateTapped
    case endDateToggleTapped
    case timeToggleTapped
    case alarmToggleTapped
    case alarmOptionTapped

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
    case addScheduleResponse(TaskResult<Int>)
    case editScheduleResponse(TaskResult<Int>)

    // Navigation
    case scheduleDetail(PresentationAction<ScheduleDetailAction>)
  }

  @Dependency(\.apiClient) var apiClient

  var body: some ReducerProtocolOf<Self> {
    Reduce { state, action in
      switch action {
      case .contentTapped(let type):
        self.handleContentTapped(state: &state, type: type)
      case .endDateToggleTapped:
        state.isEndDateActive = !state.isEndDateActive
        if state.isEndDateActive {
          state.endDate = state.startDate.addDays(by: 1)
        } else {
          state.showDateBottomSheet = false
        }
      case .timeToggleTapped:
        state.isTimeActive = !state.isTimeActive
      case .alarmToggleTapped:
        state.isAlarmActive = !state.isAlarmActive
      case .alarmOptionTapped:
        state.showAlarmBottomSheet = true
      case .titleEdited(let title):
        state.title = title
      case .memoEdited(let memo):
        state.memo = memo
      case .colorSelected(let color):
        state.color = color
        state.showColorBottomSheet = false
      case .alarmSelected(let alarm):
        state.alarm = alarm
        state.showAlarmBottomSheet = false
      case .yearSelected(let year):
        state.year = year
        switch state.focusedType {
        case .startDate:
          state.startDate = Date.with(year: year, month: state.month, day: state.day)
          if state.startDate.isLater(than: state.endDate) {
            state.endDate = state.startDate.addDays(by: 1)
          }
        case .endDate:
          state.endDate = Date.with(year: year, month: state.month, day: state.day)
          if state.startDate.isLater(than: state.endDate) {
            state.startDate = state.endDate.addDays(by: -1)
          }
        default:
          break
        }
      case .monthSelected(let month):
        state.month = month
        switch state.focusedType {
        case .startDate:
          state.startDate = Date.with(year: state.year, month: month, day: state.day)
          if state.startDate.isLater(than: state.endDate) {
            state.endDate = state.startDate.addDays(by: 1)
          }
        case .endDate:
          state.endDate = Date.with(year: state.year, month: month, day: state.day)
          if state.startDate.isLater(than: state.endDate) {
            state.startDate = state.endDate.addDays(by: -1)
          }
        default:
          break
        }
      case .daySelected(let day):
        state.day = day
        switch state.focusedType {
        case .startDate:
          state.startDate = Date.with(year: state.year, month: state.month, day: day)
          if state.startDate.isLater(than: state.endDate) {
            state.endDate = state.startDate.addDays(by: 1)
          }
        case .endDate:
          state.endDate = Date.with(year: state.year, month: state.month, day: day)
          if state.startDate.isLater(than: state.endDate) {
            state.startDate = state.endDate.addDays(by: -1)
          }
        default:
          break
        }
      case .hourSelected(let hour):
        state.time.hour = hour
        switch state.focusedType {
        case .startTime:
          state.startTime.hour = hour
          if state.startTime.isLater(than: state.endTime) {
            state.endTime = state.startTime.addOneHour()
          }
        case .endTime:
          state.endTime.hour = hour
          if state.startTime.isLater(than: state.endTime) {
            state.startTime = state.endTime.subtractOneHour()
          }
        default:
          break
        }
      case .minuteSelected(let minute):
        state.time.minute = minute
        switch state.focusedType {
        case .startTime:
          state.startTime.minute = minute
          if state.startTime.isLater(than: state.endTime) {
            state.endTime = state.startTime.addOneHour()
          }
        case .endTime:
          state.endTime.minute = minute
          if state.startTime.isLater(than: state.endTime) {
            state.startTime = state.endTime.subtractOneHour()
          }
        default:
          break
        }
      case .meridiemSelected(let meridiem):
        state.time.meridiem = meridiem
        switch state.focusedType {
        case .startTime:
          state.startTime.meridiem = meridiem
          if state.startTime.isLater(than: state.endTime) {
            state.endTime = state.startTime.addOneHour()
          }
        case .endTime:
          state.endTime.meridiem = meridiem
          if state.startTime.isLater(than: state.endTime) {
            state.startTime = state.endTime.subtractOneHour()
          }
        default:
          break
        }
      case .hideColorBottomSheet:
        state.showColorBottomSheet = false
      case .hideDateBottomSheet:
        state.showDateBottomSheet = false
      case .hideTimeBottomSheet:
        state.showTimeBottomSheet = false
      case .hideAlarmBottomSheet:
        state.showAlarmBottomSheet = false
      case .dateInitialied:
        self.handleDateInitialized(state: &state)
      case .timeInitialied:
        self.handleTimeInitialized(state: &state)
      case .scheduleDetail(.presented(.backButtonTapped)):
        state.scheduleDetail = nil

      // Network
      case .confirmTapped:
        if state.title.isEmpty { break }
        let request = AddScheduleRequest(
          id: state.idForEditing,
          title: state.title,
          memo: state.memo,
          color: state.color,
          alarm: state.alarm,
          startDate: state.startDate.to(dateFormat: Date.Format.YMDDivided),
          endDate: state.endDate.to(dateFormat: Date.Format.YMDDivided),
          startTime: state.startTime.toHMS(),
          endTime: state.endTime.toHMS()
        )
        if let id = state.idForEditing {
          return .task {
              .editScheduleResponse(
                await TaskResult {
                  try await self.apiClient.request(.editSchedule(addSchedule: request))
                }
              )
          }
        } else {
          return .task {
              .addScheduleResponse(
                await TaskResult {
                  try await self.apiClient.request(.addSchedule(addSchedule: request))
                }
              )
          }
        }
      default:
        break
      }
      return .none
    }
    .ifLet(\.$scheduleDetail, action: /ScheduleAddAction.scheduleDetail) {
      ScheduleDetailCore()
    }
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
      self.initializeDate(state: &state, date: date)
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
      self.initializeDate(state: &state, date: state.startDate)
      if state.startDate.isLater(than: state.endDate) {
        state.endDate = state.startDate.addDays(by: 1)
      }
    case .endDate:
      state.endDate = state.startDate.addDays(by: 1)
      self.initializeDate(state: &state, date: state.endDate)
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

  private func initializeDate(state: inout State, date: Date) {
    state.year = date.year
    state.month = date.month
    state.day = date.day
  }
}
