//
//  ContentView.swift
//  wooda
//
//  Created by 황득연 on 2023/05/05.
//

import ComposableArchitecture
import SwiftUI

struct RootView: View {
    let store = Store(
        initialState: Root.State(),
        reducer: Root()._printChanges()
    )
    
    var body: some View {
        SwitchStore(self.store) {
            CaseLet(state: /Root.State.home, action: Root.Action.home) { store in
                NavigationView {
                    HomeView(store: store)
                }
            }
            CaseLet(state: /Root.State.onboarding, action: Root.Action.onboarding) { store in
                NavigationView {
                    OnboardingView(store: store)
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
