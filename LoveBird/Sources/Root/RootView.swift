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
  let viewStore: ViewStore<State, RootAction>

  // RootState의 Equatable를 상속받기 위해 구현
  struct State: Equatable {
      init(state: RootState) {}
  }

  init(store: StoreOf<RootCore>) {
    self.store = store
    self.viewStore = ViewStore(store, observe: State.init)
  }
  
  var body: some View {
    SwitchStore(self.store) { state in
      switch state {
      case .splash:
        SplashView()

      case .onboarding:
        CaseLet(/RootCore.State.onboarding, action: RootCore.Action.onboarding) { store in
          OnboardingView(store: store)
        }

      case .mainTab:
        CaseLet(/RootCore.State.mainTab, action: RootCore.Action.mainTab) { store in
          MainTabView(store: store)
        }
        
      case .login:
        CaseLet(/RootCore.State.login, action: RootCore.Action.login) { store in
          LoginView(store: store)
        }
      case .coupleLink:
        CaseLet(/RootCore.State.coupleLink, action: RootCore.Action.coupleLink) { store in
          CoupleLinkView(store: store)
        }
      case .diary:
        CaseLet(/RootCore.State.diary, action: RootCore.Action.diary) { store in
          DiaryView(store: store)
        }
      }
    }
    .onAppear {
      self.viewStore.send(.viewAppear)
    }
  }
}

