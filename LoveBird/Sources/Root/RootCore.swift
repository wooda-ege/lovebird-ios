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
        
//        init() { self = .onboarding(OnboardingCore.State())}
        init() { self = .mainTab(MainTabCore.State())}
    }
    enum Action: Equatable {
        case onboarding(OnboardingCore.Action)
        case mainTab(MainTabCore.Action)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onboarding(.doneButtonTapped):
                state = .mainTab(MainTabCore.State())
            case .onboarding(.signUpResponse(.success(let reponse))):
                // TODO: 득연
                break
            case .onboarding(.signUpResponse(.failure(let error))):
                // TODO: 득연
                break
            default:
                break
            }
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
