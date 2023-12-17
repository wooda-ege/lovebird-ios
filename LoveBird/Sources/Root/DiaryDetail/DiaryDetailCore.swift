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
    let diary: HomeDiary
    var nickname: String?
    var showBottomSheet = false
  }

  enum Action: Equatable {
    case backTapped
    case editDeleteButtonTapped
    case editButtonTapped
    case deleteTapped
    case deleteDiaryResponse(TaskResult<StatusCode>)

    case delegate(Delegate)
    enum Delegate: Equatable {
      case editTapped(HomeDiary)
    }
  }

  @Dependency(\.lovebirdApi) var lovebirdApi
  @Dependency(\.dismiss) var dismiss
  @Dependency(\.userData) var userData

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .optionButtonTapped:
      case .editDeleteButtonTapped:
        state.showBottomSheet = true
        return .none

      case .editButtonTapped:
        // TODO:: 수정하기 구현
        return .none

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

      default:
        return .none
      }
    }
  }
}

typealias DiaryDetailState = DiaryDetailCore.State
typealias DiaryDetailAction = DiaryDetailCore.Action
