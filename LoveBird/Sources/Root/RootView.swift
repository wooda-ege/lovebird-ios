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
      alertView
      toastView
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
        ProgressView()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .background(.black.opacity(0.01))
          .background {
            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10), style: .circular)
              .fill(Color.black.opacity(0.2))
              .frame(size: 60)
          }
      }
    }
  }

  var alertView: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      if let style = viewStore.alertStyle {
        ZStack(alignment: .center) {
          VStack {
            Spacer()
              .frame(height: 32)

            Text(style.title)
              .font(.pretendard(size: 16, weight: .bold))

            Spacer()
              .frame(height: 8)

            Text(style.description)
              .font(.pretendard(size: 14))

            Spacer()
              .frame(height: 32)

            HStack(spacing: 4) {
              Button { viewStore.send(.negativeTapped) } label: {
                Text(style.negativeButton)
                  .font(.pretendard(size: 16, weight: .bold))
                  .padding(.vertical, 18)
                  .foregroundStyle(Color.black)
                  .frame(maxWidth: .infinity)
              }

              Button { viewStore.send(.positiveTapped) } label: {
                Text(style.positiveButton)
                  .font(.pretendard(size: 16, weight: .bold))
                  .padding(.vertical, 18)
                  .frame(maxWidth: .infinity)
                  .background(Color.black)
                  .foregroundStyle(Color.white)
                  .clipShape(RoundedRectangle(cornerRadius: 12))
              }
            }
            .padding(.horizontal, 24)

            Spacer()
              .frame(height: 32)
          }
          .frame(width: UIScreen.width - 32)
          .background(Color.white)
          .clipShape(RoundedRectangle(cornerRadius: 12))
          .shadow(color: .black.opacity(0.16), radius: 12, x: 0, y: 4)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black.opacity(0.01))
      }
    }
  }

  var toastView: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack {
        if let message = viewStore.toastMessage {
          VStack {
            Spacer()

            HStack(alignment: .center, spacing: 8) {
              Text(message)
                .font(.pretendard(size: 14))
                .foregroundColor(.white)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(.black.opacity(0.88))
            .cornerRadius(4)
            .transition(.opacity)

            Spacer()
              .frame(height: 66)
          }
        }
      }
      .animation(Animation.easeInOut(duration: 0.3), value: viewStore.toastMessage)
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
