//
//  DiaryCore.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/28.
//

import ComposableArchitecture

struct DiaryCore: ReducerProtocol {
    
    struct State: Equatable {
    }
    
    enum Action: Equatable {
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            default:
                return .none
            }
        }
    }
}
