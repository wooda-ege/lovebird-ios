//
//  OnboardingCore.swift
//  wooda
//
//  Created by 황득연 on 2023/05/09.
//

import ComposableArchitecture
import SwiftUIPager
import Foundation

struct OnboardingCore: ReducerProtocol {
  struct State: Equatable {
    var page: Page = .first()
    var nickname: String = ""
    var textFieldState: TextFieldState = .none
    var showBottomSheet = false
    var year: Int = Calendar.year
    var month: Int = Calendar.month
    var day: Int = Calendar.day
  }
  
  enum Action: Equatable {
    case nextTapped
    case previousTapped
    case nextButtonTapped
    case textFieldStateChanged(TextFieldState)
    case yearSelected(Int)
    case monthSelected(Int)
    case daySelected(Int)
    case nicknameEdited(String)
    case doneButtonTapped
    case showBottomSheet
    case hideBottomSheet
    case dateInitialied
    case signUpResponse(TaskResult<SignUpResponse>)
    case none
  }
  
  @Dependency(\.apiClient) var apiClient
  
  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .nextTapped, .nextButtonTapped:
        guard state.page.index == 0, state.textFieldState == .correct else { return .none }
        state.page.update(.next)
      case .textFieldStateChanged(let textFieldState):
        state.textFieldState = textFieldState
      case .previousTapped:
        guard state.page.index == 1 else { return .none }
        state.page.update(.previous)
      case .nicknameEdited(let nickname):
        state.nickname = nickname
        if nickname.isNicknameValid {
          state.textFieldState = nickname.count >= 2 ? .correct : .editing
        } else {
          state.textFieldState = .error
        }
      case .yearSelected(let year):
        state.year = year
      case .monthSelected(let month):
        state.month = month
      case .daySelected(let day):
        state.day = day
      case .showBottomSheet:
        state.showBottomSheet = true
      case .hideBottomSheet:
        state.showBottomSheet = false
      case .dateInitialied:
        state.year = Calendar.year
        state.month = Calendar.month
        state.day = Calendar.day
      case .doneButtonTapped:
        return .task { [nickname = state.nickname, year = state.year, month = state.month, day = state.day] in
            .signUpResponse(
              await TaskResult {
                try await self.apiClient.request(.signUp(.init(
                  nickname: nickname,
                  firstDate: "\(year)-\(month)-\(day)")
                ))
              }
            )
        }
      default:
        break
      }
      return .none
    }
  }
}

extension Page: Equatable {
  public static func == (lhs: SwiftUIPager.Page, rhs: SwiftUIPager.Page) -> Bool {
    lhs.index == rhs.index
  }
}
