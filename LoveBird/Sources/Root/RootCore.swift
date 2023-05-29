//
//  RootCore.swift
//  wooda
//
//  Created by 황득연 on 2023/05/06.
//

import ComposableArchitecture

struct RootCore: ReducerProtocol {
    enum State: Equatable {
        case onboarding(OnboardingCore.State)
        case mainTab(MainTabCore.State)
        
        init() { self = .onboarding(OnboardingCore.State())}
    }
    enum Action: Equatable {
        case onboarding(OnboardingCore.Action)
        case mainTab(MainTabCore.Action)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            return .none
        }
        .ifCaseLet(/State.onboarding, action: /Action.onboarding) {
            OnboardingCore()
        }
        .ifCaseLet(/State.mainTab, action: /Action.mainTab) {
            MainTabCore()
        }
    }
    
}
