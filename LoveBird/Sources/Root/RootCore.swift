//
//  RootCore.swift
//  wooda
//
//  Created by 황득연 on 2023/05/06.
//

import ComposableArchitecture

struct Root: ReducerProtocol {
    enum State: Equatable {
        case home(HomeCore.State)
        case onboarding(OnboardingCore.State)
        
        init() {
//            self = .home(Home.State())
            self = .onboarding(OnboardingCore.State())
        }
    }
    enum Action: Equatable {
        case home(HomeCore.Action)
        case onboarding(OnboardingCore.Action) 
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .home:
                state = .home(HomeCore.State())
                return .none
            case .onboarding:
                state = .onboarding(OnboardingCore.State())
                return .none
            }
        }
        .ifCaseLet(/State.home, action: /Action.home) {
            HomeCore()
        }
        .ifCaseLet(/State.onboarding, action: /Action.onboarding) {
            OnboardingCore()
        }
    }
    
}
