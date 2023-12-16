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
      case .splash:
        CaseLet(
          /RootCore.State.splash,
           action: RootCore.Action.splash,
           then: SplashView.init
        )

      case .onboarding:
        CaseLet(
          /RootCore.State.onboarding,
           action: RootCore.Action.onboarding,
           then: OnboardingView.init
        )

      case .mainTab:
        CaseLet(
          /RootCore.State.mainTab,
           action: RootCore.Action.mainTab,
           then: MainTabView.init
        )

      case .login:
        CaseLet(
          /RootCore.State.login,
           action: RootCore.Action.login,
           then: LoginView.init
        )

      case .coupleLink:
        CaseLet(
          /RootCore.State.coupleLink,
           action: RootCore.Action.coupleLink,
           then: CoupleLinkView.init
        )
      }
    }
  }
}

#Preview {
  RootView(
    store: .init(
      initialState: RootState(),
      reducer: { RootCore() }
    )
  )
}
