//
//  ContentView.swift
//  wooda
//
//  Created by 황득연 on 2023/05/05.
//

import ComposableArchitecture
import SwiftUI
import Combine

struct RootView: View {
  let store: StoreOf<RootCore>

  var body: some View {
    ZStack {
      rootView
      loadingView
    }
  }
}

// MARK: - Child Views

extension RootView {
  var rootView: some View {
    SwitchStore(store.scope(state: \.path, action: RootAction.path)) { state in
      switch state {
      case .splash:
        CaseLet(
          /RootCore.Path.State.splash,
           action: RootCore.Path.Action.splash,
           then: SplashView.init
        )

      case .onboarding:
        CaseLet(
          /RootCore.Path.State.onboarding,
           action: RootCore.Path.Action.onboarding,
           then: OnboardingView.init
        )

      case .mainTab:
        CaseLet(
          /RootCore.Path.State.mainTab,
           action: RootCore.Path.Action.mainTab,
           then: MainTabView.init
        )

      case .login:
        CaseLet(
          /RootCore.Path.State.login,
           action: RootCore.Path.Action.login,
           then: LoginView.init
        )

      case .coupleLink:
        CaseLet(
          /RootCore.Path.State.coupleLink,
           action: RootCore.Path.Action.coupleLink,
           then: CoupleLinkView.init
        )
      }
    }
    .onAppear {
        store.send(.viewAppear)
    }
  }

  var loadingView: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      if viewStore.isLoading {
        ZStack(alignment: .center) {
          ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
              RoundedRectangle(cornerSize: CGSize(width: 10, height: 10), style: .circular)
                .fill(Color.black.opacity(0.2))
                .frame(size: 60)
            }
        }
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
