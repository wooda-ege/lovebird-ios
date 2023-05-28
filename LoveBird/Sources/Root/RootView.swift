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
        WithViewStore(self.store) { viewStore in
            if !viewStore.isOnboarding {
                OnboardingView(store: Store(initialState: OnboardingCore.State(), reducer: OnboardingCore()._printChanges()))
            } else {
                MainTabView(store: Store(
                    initialState: MainTabCore.State(),
                    reducer: MainTabCore()._printChanges()
                ))
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(store: Store(initialState: RootCore.State(), reducer: RootCore()._printChanges()))
    }
}
