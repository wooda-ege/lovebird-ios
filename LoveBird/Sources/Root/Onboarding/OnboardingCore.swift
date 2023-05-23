//
//  OnboardingCore.swift
//  wooda
//
//  Created by 황득연 on 2023/05/09.
//

import ComposableArchitecture
import SwiftUIPager

struct Onboarding: ReducerProtocol {
    struct State: Equatable {
        var page: Page = .first()
        var a: Int = 0
    }
    
    enum Action: Equatable, Sendable {
        case nextTapped
        case previousTapped
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .nextTapped:
            guard state.page.index == 0 else { return .none }
//            state.a += 1
//            print(state.a)
//            state.page.update(.next)
            return .none
        case .previousTapped:
            guard state.page.index == 1 else { return .none }
//            state.page.update(.previous)
            return .none
        }
    }
}

extension Page: Equatable {
    public static func == (lhs: SwiftUIPager.Page, rhs: SwiftUIPager.Page) -> Bool {
        lhs.index == rhs.index
    }
}
