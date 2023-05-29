//
//  OnboardingCore.swift
//  wooda
//
//  Created by 황득연 on 2023/05/09.
//

import ComposableArchitecture
import SwiftUIPager

struct OnboardingCore: ReducerProtocol {
    struct State: Equatable {
        var page: Page = .first()
        var nickname: String = ""
        var textFieldState: TextFieldState = .none
        var year: String = ""
        var month: String = ""
        var day: String = ""
    }
    
    enum Action: Equatable {
        case nextTapped
        case previousTapped
        case nextButtonTapped
        case textFieldStateChanged(TextFieldState)
        case yearSelected(String)
        case monthSelected(String)
        case daySelected(String)
        case nicknameEdited(String)
        case doneButtonTapped
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .nextTapped, .nextButtonTapped:
                guard state.page.index == 0, state.textFieldState == .correct else { return .none }
                state.page.update(.next)
                return .none
            case .textFieldStateChanged(let textFieldState):
                state.textFieldState = textFieldState
                return .none
            case .previousTapped:
                guard state.page.index == 1 else { return .none }
                state.page.update(.previous)
                return .none
            case .nicknameEdited(let nickname):
                state.nickname = nickname
                if nickname.isNicknameValid {
                    state.textFieldState = nickname.count >= 2 ? .correct : .editing
                } else {
                    state.textFieldState = .error
                }
                return .none
            case .yearSelected(let year):
                state.year = year
                return .none
            case .monthSelected(let month):
                state.month = month
                return .none
            case .daySelected(let day):
                state.day = day
                return .none
            case .doneButtonTapped:
                return .none
            }
        }
    }
}

extension Page: Equatable {
    public static func == (lhs: SwiftUIPager.Page, rhs: SwiftUIPager.Page) -> Bool {
        lhs.index == rhs.index
    }
}
