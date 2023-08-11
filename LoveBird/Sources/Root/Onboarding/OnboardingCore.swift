//
//  OnboardingCore.swift
//  wooda
//
//  Created by 황득연 on 2023/05/09.
//

import ComposableArchitecture
import SwiftUIPager
import Foundation

typealias OnboardingState = OnboardingCore.State
typealias OnboardingAction = OnboardingCore.Action

struct OnboardingCore: ReducerProtocol {
  
  enum Constant {
    static let nicknamePageIdx = 0
    static let maxNicknameLength = 20
    static let minNicknameLength = 2
  }
  
  struct State: Equatable {
    var page: Page = .first()
    var pageIdx: Int = Constant.nicknamePageIdx
    var nickname: String = ""
    var textFieldState: TextFieldState = .none
    var showBottomSheet = false
    var year: Int = Date().year
    var month: Int = Date().month
    var day: Int = Date().day
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
        guard state.page.isNickname, state.textFieldState == .correct else { return .none }
        state.page.update(.next)
        state.pageIdx = 1
      case .textFieldStateChanged(let textFieldState):
        state.textFieldState = textFieldState
      case .previousTapped:
        guard !state.page.isNickname else { return .none }
        state.pageIdx = 0
        state.page.update(.previous)
      case .nicknameEdited(let nickname):
        state.nickname = String(nickname.prefix(20))
        if nickname.isNicknameValid {
          state.textFieldState = nickname.count >= Constant.minNicknameLength ? .correct : .editing
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
        state.year = Date().year
        state.month = Date().month
        state.day = Date().day
      case .doneButtonTapped:
//        return .task { [nickname = state.nickname, year = state.year, month = state.month, day = state.day] in
//            .signUpResponse(
//              await TaskResult {
//                try await self.apiClient.request(.signUp(.init(
//                  nickname: nickname,
//                  firstDate: "\(year)-\(month)-\(day)")
//                ))
//              }
//            )
//        }
        break
      default:
        break
      }
      return .none
    }
  }
}

extension Page: Equatable {
  public static func == (lhs: Page, rhs: Page) -> Bool {
    lhs.index == rhs.index
  }
}
