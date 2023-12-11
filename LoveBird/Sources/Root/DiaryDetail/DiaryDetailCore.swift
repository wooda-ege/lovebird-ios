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
    let diary: Diary
    var nickname: String?
  }

  enum Action: Equatable {
    case backTapped
    case deleteDiary
    case deleteDiaryResponse(TaskResult<String>)

    case delegate(Delegate)
    enum Delegate: Equatable {
      case editTapped(Diary)
    }
  }

  @Dependency(\.apiClient) var apiClient
  @Dependency(\.dismiss) var dismiss
  @Dependency(\.userData) var userData

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {

      case .backTapped:
        return .run { _ in await dismiss() }

      case .deleteDiary:
				return .run { [id = state.diary.diaryId] send in
					await send(
						.deleteDiaryResponse(
							await TaskResult {
								try await apiClient.requestRaw(.deleteDiary(id: id))
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
