//
//  DiaryCore.swift
//  JsonPractice
//
//  Created by 이예은 on 2023/05/30.
//

import ComposableArchitecture
import SwiftUI

typealias DiaryState = DiaryCore.State
typealias DiaryAction = DiaryCore.Action

struct DiaryCore: ReducerProtocol {
  struct State: Equatable {
    @PresentationState var searchPlace: SearchPlaceState?

    var focusedType: DiaryFocusedType = .none
    var title: String = ""
    var content: String = ""
    var place: String = ""
    var date = Date()

    var isPresented = false
    var image: UIImage? = nil
    var showCalendarPreview: Bool = false
  }
  
  enum Action: Equatable {
    case searchPlace(PresentationAction<SearchPlaceAction>)
    case dateTapped(Date)
    case titleEdited(String)
    case contentEdited(String)
    case focusedTypeChanged(DiaryFocusedType)
    case placeTapped
    case previewFollowingTapped
    case previewNextTapped
    case previewDayTapped(Date)

    case selectPlaceLabelTapped
    case changeTextEmpty
    case completeTapped
    case registerDiaryResponse(TaskResult<String>)
    case hideDateView
    case viewInitialized
  }
  
  @Dependency(\.apiClient) var apiClient
  @Dependency(\.userData) var userData
  
  var body: some ReducerProtocol<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .titleEdited(let title):
        state.title = title
        return .none

      case .contentEdited(let content):
        state.content = content
        return .none

      case .selectPlaceLabelTapped:
        return .none

      case .changeTextEmpty:
        state.content = ""
        return .none

      case .placeTapped:
        state.searchPlace = SearchPlaceState()
        return .none

      case .focusedTypeChanged(let type):
        state.focusedType = type
        state.showCalendarPreview = type == .date
        return .none

      case .previewFollowingTapped:
        state.date = state.date.addMonths(by: -1)
        return .none

      case .previewNextTapped:
        state.date = state.date.addMonths(by: 1)
        return .none

      case .previewDayTapped(let date):
        state.date = date
        state.focusedType = .none
        state.showCalendarPreview = false
        return .none

      case .dateTapped:
        state.showCalendarPreview = true
        state.focusedType = .date
        return .none

      case .searchPlace(.presented(.selectPlace(let place))), .searchPlace(.presented(.completeTapped(let place))):
        state.place = place
        state.searchPlace = nil
        return .none

      case .searchPlace(.presented(.backTapped)):
        state.searchPlace = nil
        return .none

      case .completeTapped:
        if state.title.isEmpty || state.content.isEmpty { return .none }
        return .task { [state = state] in
          .registerDiaryResponse(
            await TaskResult {
              try await self.apiClient.requestRaw(
                .registerDiary(
                  image: state.image,
                  diary: .init(
                    title: state.title,
                    memoryDate: state.date.to(dateFormat: Date.Format.YMDDivided),
                    place: state.place.isEmpty ? nil : state.place,
                    content: state.content)
                )
              )
            }
          )
        }

      case .registerDiaryResponse(.success):
        state.title = ""
        state.date = Date()
        state.place = ""
        state.content = ""
        return .none

      default:
        return .none
      }
    }
    .ifLet(\.$searchPlace, action: /Action.searchPlace) {
      SearchPlaceCore()
    }
  }
}
