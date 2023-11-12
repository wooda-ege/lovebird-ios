//
//  DiaryDetailCore.swift
//  LoveBird
//
//  Created by 황득연 on 2023/08/19.
//

import UIKit
import ComposableArchitecture

typealias DiaryDetailState = DiaryDetailCore.State
typealias DiaryDetailAction = DiaryDetailCore.Action

struct DiaryDetailCore: Reducer {

  struct State: Equatable {
    let diary: Diary
    var nickname: String?
    var showBottomSheet = false
  }

  enum Action: Equatable {
    case backTapped
    case editDeleteButtonTapped
    case editButtonTapped
    case deleteButtonTapped
    case deleteDiaryResponse(TaskResult<String>)
  }

  @Dependency(\.apiClient) var apiClient
  @Dependency(\.userData) var userData

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .editDeleteButtonTapped:
        state.showBottomSheet = true
        return .none
      case .deleteButtonTapped:
				return .run { [id = state.diary.diaryId] send in
					await send(
						.deleteDiaryResponse(
							await TaskResult {
								try await self.apiClient.requestRaw(.deleteDiary(id: id))
							}
						)
					)
				}
      case .editButtonTapped:
        return .run { [id = state.diary.diaryId] send in
          await send(
            .edit
          )
        }
      default:
        return .none
      }
    }
  }
}
