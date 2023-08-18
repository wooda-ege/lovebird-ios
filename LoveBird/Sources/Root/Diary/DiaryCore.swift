//
//  DiaryCore.swift
//  JsonPractice
//
//  Created by 이예은 on 2023/05/30.
//

import ComposableArchitecture
import SwiftUI

struct DiaryCore: ReducerProtocol {
  struct State: Equatable {
    var searchPlace: SearchPlaceCore.State = SearchPlaceCore.State()
    var calendarDate: CalendarCore.State = CalendarCore.State()
    var title: String = ""
    var date: String = String(resource: R.string.localizable.calendar_date)
    var place: String = String(resource: R.string.localizable.diary_select_place)
    var isPresented = false
    var text: String = ""
    var image: UIImage? = nil
    var showCalendarPreview: Bool = false
  }
  
  enum Action: Equatable {
    case searchPlace(SearchPlaceCore.Action)
    case calendarDate(CalendarCore.Action)
    case titleLabelTapped(String)
    case selectPlaceLabelTapped
    case textDidEditting(String)
    case changeTextEmpty
    case completeButtonTapped
    case registerDiaryResponse(TaskResult<String>)
    case hideDateView
    case viewInitialized
  }
  
  @Dependency(\.apiClient) var apiClient
  @Dependency(\.userData) var userData
  
  var body: some ReducerProtocol<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .calendarDate(.dayTapped(let date)):
        let date = date.to(dateFormat: Date.Format.YMDDivided)
        state.date = date
      case .titleLabelTapped(let title):
        state.title = title
        return .none
      case .selectPlaceLabelTapped:
        return .none
      case .textDidEditting(let text):
        state.text = text
        return .none
      case .changeTextEmpty:
        state.text = ""
      case .completeButtonTapped:
        return .run { [state = state] send in
          let response = try await apiClient.requestRaw(.registerDiary(authorization: userData.get(key: .accessToken, type: String.self)!, refresh: userData.get(key: .refreshToken, type: String.self) ?? "", image: state.image, diary: .init(title: state.title, memoryDate: state.date, place: state.place, content: state.text))) as String
          
          await send(.registerDiaryResponse(.success(response)))
          await send(.viewInitialized)
        }
      case .viewInitialized:
        state.title = ""
        state.date = String(resource: R.string.localizable.calendar_date)
        state.place = String(resource: R.string.localizable.diary_select_place)
        state.text = ""
      case .searchPlace(.selectPlace(let place)):
        state.place = place
      case .hideDateView:
        state.showCalendarPreview = true
      default:
        break
      }
      return .none
    }
    Scope(state: \.searchPlace, action: /Action.searchPlace) {
      SearchPlaceCore()
    }
    
    Scope(state: \.calendarDate, action: /Action.calendarDate) {
      CalendarCore()
    }
  }
}
