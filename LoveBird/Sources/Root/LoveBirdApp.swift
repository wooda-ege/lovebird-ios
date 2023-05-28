//
//  LoveBirdApp.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/13.
//

import SwiftUI
import ComposableArchitecture

@main
struct LoveBirdApp: App {
    var body: some Scene {
        
        WindowGroup {
            RootView(store: Store(
                initialState: RootCore.State(),
                reducer: RootCore()._printChanges()
            ))
            .preferredColorScheme(.light)
        }
    }
}
