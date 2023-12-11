//
//  DiaryCore.swift
//  JsonPractice
//
//  Created by 이예은 on 2023/05/30.
//

import ComposableArchitecture
import SwiftUI

struct DiaryCore: Reducer {
  struct State: Equatable {
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
    case dateTapped(Date)
    case titleEdited(String)
    case contentEdited(String)
    case focusedTypeChanged(DiaryFocusedType)
    case placeTapped
    case previewFollowingTapped
    case previewNextTapped
    case previewDayTapped(Date)

    case placeUpdated(String)
    case changeTextEmpty
    case completeTapped
    case addDiaryResponse(TaskResult<StatusCode>)
    case hideDateView
    case viewInitialized
    case editImage(UIImage?)
  }
  
  @Dependency(\.lovebirdApi) var lovebirdApi
  @Dependency(\.userData) var userData
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .titleEdited(let title):
        state.title = title
        return .none
        
      case .contentEdited(let content):
        state.content = content
        return .none
        
      case .changeTextEmpty:
        state.content = ""
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
        
      case .completeTapped:
        if state.title.isEmpty || state.content.isEmpty { return .none }
        return .run { [state] send in
          await send(
            .addDiaryResponse(
              await TaskResult {
                try await self.lovebirdApi.addDiary(
                  image: state.image?.pngData(),
                  diary: .init(
                    title: state.title,
                    memoryDate: state.date.to(dateFormat: Date.Format.YMDDivided),
                    place: state.place.isEmpty ? nil : state.place,
                    content: state.content
                  )
                )
              }
            )
          )
        }

      case let .placeUpdated(place):
        state.place = place
        return .none

      case let .placeUpdated(place):
        state.place = place
        return .none

      case .editImage(let image):
        state.image = image
        return .none
        
      case .addDiaryResponse(.success):
        state.title = ""
        state.date = Date()
        state.place = ""
        state.content = ""
        state.image = nil
        return .none

      default:
        return .none
      }
    }
  }
}

typealias DiaryState = DiaryCore.State
typealias DiaryAction = DiaryCore.Action
