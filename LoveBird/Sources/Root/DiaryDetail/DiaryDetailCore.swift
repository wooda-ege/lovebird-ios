//
//  DiaryDetailCore.swift
//  LoveBird
//
//  Created by 황득연 on 2023/08/19.
//

import UIKit
import ComposableArchitecture

struct DiaryDetailCore: Reducer {

  struct State: Equatable {
    var diary: Diary
    var nickname: String?
    var selectedImageURLString: String = ""
    var isImageViewerShown: Bool = false
  }

  enum Action: Equatable {
    case backTapped
    case editTapped
    case deleteTapped
    case deleteDiaryResponse(TaskResult<StatusCode>)
    case imageTapped(String)
    case showImageViewer(Bool)
    case diaryReloaded
    case diaryUpdated(Diary)

    case delegate(Delegate)
    enum Delegate: Equatable {
      case editTapped(Diary)
    }
  }

  @Dependency(\.lovebirdApi) var lovebirdApi
  @Dependency(\.dismiss) var dismiss
  @Dependency(\.userData) var userData

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .editTapped:
        return .send(.delegate(.editTapped(state.diary)))

      case .backTapped:
        return .run { _ in await dismiss() }

      case .deleteTapped:
        return .run { [id = state.diary.diaryId] send in
          await send(
            .deleteDiaryResponse(
              await TaskResult {
                try await lovebirdApi.deleteDiary(id: id)
              }
            )
          )
        }

      case let .imageTapped(urlString):
        state.selectedImageURLString = urlString
        return .send(.showImageViewer(true))

      case let .showImageViewer(visible):
        state.isImageViewerShown = visible
        return .none

      case .diaryReloaded:
        return .run { [state] send in
          let diary = try await self.lovebirdApi.fetchDiary(id: state.diary.diaryId)
          await send(.diaryUpdated(diary))
        }

      case let .diaryUpdated(diary):
        state.diary = diary
        return .none

      default:
        return .none
      }
    }
  }
}

typealias DiaryDetailState = DiaryDetailCore.State
typealias DiaryDetailAction = DiaryDetailCore.Action
