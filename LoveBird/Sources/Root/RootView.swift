//
//  ContentView.swift
//  wooda
//
//  Created by 황득연 on 2023/05/05.
//

import ComposableArchitecture
import SwiftUI

struct RootView: View {
    let store: StoreOf<RootCore>

    var body: some View {
        SwitchStore(self.store) { state in
            switch state {
            case .onboarding:
                CaseLet(/RootCore.State.onboarding, action: RootCore.Action.onboarding) { store in
                    OnboardingView(store: store)
                }
            case .mainTab:
                CaseLet(/RootCore.State.mainTab, action: RootCore.Action.mainTab) { store in
                    MainTabView(store: store)
                }
            }
        }
    }
}
