//
//  RootCore.swift
//  wooda
//
//  Created by 황득연 on 2023/05/06.
//

import ComposableArchitecture

struct Root: ReducerProtocol {
    enum State: Equatable {
        case home(Home.State)
        case onboarding(Onboarding.State)
        
        init() {
            self = .home(Home.State())
        }
    }
    enum Action: Equatable {
        case home(Home.Action)
        case onboarding(Onboarding.Action) 
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .home:
                state = .home(Home.State())
                return .none
            case .onboarding:
                state = .onboarding(Onboarding.State())
                return .none
            }
        }
        .ifCaseLet(/State.home, action: /Action.home) {
            Home()
        }
        .ifCaseLet(/State.onboarding, action: /Action.onboarding) {
            Onboarding()
        }
    }
    
}
