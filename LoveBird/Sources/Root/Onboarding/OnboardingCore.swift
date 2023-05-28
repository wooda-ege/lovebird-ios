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
    }
    
    enum Action: Equatable {
        case nextTapped
        case previousTapped
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .nextTapped:
                guard state.page.index == 0 else { return .none }
                state.page.update(.next)
                return .none
            case .previousTapped:
                guard state.page.index == 1 else { return .none }
                state.page.update(.previous)
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
