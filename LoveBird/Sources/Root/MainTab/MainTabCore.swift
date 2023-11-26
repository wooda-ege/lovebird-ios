//
//  MainTabCore.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/27.
//

import Foundation
import ComposableArchitecture

typealias MainTabState = MainTabCore.State
typealias MainTabAction = MainTabCore.Action

struct MainTabCore: Reducer {

  // MARK: - Tab

  enum Tab {
    case home
    case canlander
    case diary
    case myPage
  }

  // MARK: - State

  struct State: Equatable {
    var selectedTab: Tab = .home
    var home: HomeCore.State? = HomeCore.State()
    var calander: CalendarCore.State? = CalendarCore.State()
    var diary: DiaryCore.State? = DiaryCore.State()
    var myPage: MyPageCore.State? = MyPageCore.State()
    var path = StackState<MainTabPathState>()
  }

  // MARK: - Action
  
  enum Action: Equatable {
    case tabSelected(Tab)
    case home(HomeAction)
    case calander(CalendarAction)
    case diary(DiaryAction)
    case myPage(MyPageAction)
    case path(StackAction<MainTabPathState, MainTabPathAction>)
  }

  // MARK: - Path

  struct Path: Reducer {
    enum State: Equatable {
      case diaryDetail(DiaryDetailState)
      case scheduleDetail(ScheduleDetailState)
      case scheduleAdd(ScheduleAddState)
      case searchPlace(SearchPlaceState)
      case myPageProfileEdit(MyPageProfileEditState)
    }

    enum Action: Equatable {
      case diaryDetail(DiaryDetailAction)
      case scheduleDetail(ScheduleDetailAction)
      case scheduleAdd(ScheduleAddAction)
      case searchPlace(SearchPlaceAction)
      case myPageProfileEdit(MyPageProfileEditAction)
    }

    var body: some ReducerOf<Self> {
      Scope(state: /State.diaryDetail, action: /Action.diaryDetail) {
        DiaryDetailCore()
      }
      Scope(state: /State.scheduleDetail, action: /Action.scheduleDetail) {
        ScheduleDetailCore()
      }
      Scope(state: /State.scheduleAdd, action: /Action.scheduleAdd) {
        ScheduleAddCore()
      }
      Scope(state: /State.searchPlace, action: /Action.searchPlace) {
        SearchPlaceCore()
      }
      Scope(state: /State.myPageProfileEdit, action: /Action.myPageProfileEdit) {
        MyPageProfileEditCore()
      }
    }
  }

  @Dependency(\.userData) var userData

  // MARK: - Body

  var body: some Reducer<State, Action> {
    Reduce(core)
      .ifLet(\.home, action: /Action.home) {
        HomeCore()
      }
      .ifLet(\.calander, action: /Action.calander) {
        CalendarCore()
      }
      .ifLet(\.diary, action: /Action.diary) {
        DiaryCore()
      }
      .ifLet(\.myPage, action: /Action.myPage) {
        MyPageCore()
      }
      .forEach(\.path, action: /Action.path) { Path() }
  }

  func core(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .tabSelected(let tab):
      state.selectedTab = tab
      return .none
      
    case .home(.todoDiaryTapped):
      state.selectedTab = .diary
      return .none
      
    case .home(.diaryTapped(let diary)):
      guard let user = self.userData.get(key: .user, type: Profile.self) else { return .none}
      let nickname: String?
      if let partnerNickname = user.partnerNickname {
        nickname = user.memberId == diary.memberId ? user.nickname : partnerNickname
      } else {
        nickname = nil
      }
      state.path.append(.diaryDetail(.init(diary: diary, nickname: nickname)))
      return .none
      
    case let .calander(.scheduleTapped(schedule)):
      state.path.append(.scheduleDetail(.init(schedule: schedule)))
      return .none
      
    case let .calander(.plusTapped(date)):
      state.path.append(.scheduleAdd(.init(date: date)))
      return .none
      
    case .diary(.placeTapped):
      state.path.append(.searchPlace(.init()))
      return .none
      
    case .diary(.registerDiaryResponse(.success(let response))):
      if response == "SUCCESS" {
        state.selectedTab = .home
      }
      return .none
      
    case .diary(.registerDiaryResponse(.failure)):
      print("다이어리 등록 실패")
      return .none

    case .myPage(.editTapped):
      state.path.append(.myPageProfileEdit(.init()))
      return .none

      // MARK: - Path Action Delegate
      
    case let .path(.element(id: _, action: .diaryDetail(.delegate(action)))):
      switch action {
      case let .editTapped(diary):
        state.path.append(.diaryDetail(.init(diary: diary)))
      }
      return .none
      
    case let .path(.element(id: _, action: .scheduleDetail(.delegate(action)))):
      switch action {
      case let .goToScheduleAdd(schedule):
        state.path.append(.scheduleAdd(.init(schedule: schedule)))
      }
      return .none
      
    case let .path(.element(id: _, action: .searchPlace(.delegate(action)))):
      switch action {
      case let .updatePlace(place):
        return .send(.diary(.placeUpdated(place)))
      }

    default:
      return .none
    }
  }
}

typealias MainTabPathState = MainTabCore.Path.State
typealias MainTabPathAction = MainTabCore.Path.Action
