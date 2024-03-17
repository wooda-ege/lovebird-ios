//
//  RootCore.swift
//  wooda
//
//  Created by 황득연 on 2023/05/06.
//

import UIKit
import ComposableArchitecture
import SwiftUI

struct RootCore: Reducer {

  // MARK: - Constants

  enum Constants {
    static let delayOfSplash: Int = 1
  }

  // MARK: - State

  struct State: Equatable {
    var path: Path.State = .splash(.init())
    var isLoading = false
    var alertStyle: AlertController.Style?
    var toastMessage: String?
  }

  // MARK: - Action

  enum Action: Equatable {
    case path(Path.Action)
    case switchPath(Path.State)
    case viewAppear
    case loadingVisible(Bool)
    case alertTypeApplied(AlertController.Style.`Type`?)
    case toastMessageApplied(String?)
    case negativeTapped
    case positiveTapped
  }

  // MARK: - Path

  struct Path: Reducer {
    enum State: Equatable {
      case splash(SplashState)
      case onboarding(OnboardingState)
      case mainTab(MainTabState)
      case login(LoginState)
      case coupleLink(CoupleLinkState)

      init() {
        self = .splash(.init())
      }
    }

    enum Action: Equatable {
      case splash(SplashAction)
      case onboarding(OnboardingAction)
      case mainTab(MainTabAction)
      case login(LoginAction)
      case coupleLink(CoupleLinkAction)
    }

    var body: some ReducerOf<Self> {
      Scope(state: /State.splash, action: /Action.splash) {
        SplashCore()
      }
      Scope(state: /State.onboarding, action: /Action.onboarding) {
        OnboardingCore()
      }
      Scope(state: /State.mainTab, action: /Action.mainTab) {
        MainTabCore()
      }
      Scope(state: /State.login, action: /Action.login) {
        LoginCore()
      }
      Scope(state: /State.coupleLink, action: /Action.coupleLink) {
        CoupleLinkCore()
      }
    }
  }

  // MARK: - Dependency

  @Dependency(\.lovebirdApi) var lovebirdApi
  @Dependency(\.userData) var userData
  @Dependency(\.loadingController) var loadingController
  @Dependency(\.alertController) var alertController
  @Dependency(\.toastController) var toastController

  @Dependency(\.continuousClock) var continuousClock

  // MARK: - Body

  var body: some ReducerOf<Self> {
    Scope(state: \State.path, action: /Action.path) {
      Path()
    }
    Reduce(core)
  }

  func core(state: inout State, action: Action) -> Effect<Action> {
    switch action {

      // MARK: - Splash

    case .path(.splash(.viewAppear)):
      return .run { send in
        try await continuousClock.sleep(for: .seconds(Constants.delayOfSplash))

        let rootState = switchState(with: userData.profile.value)
        await send(.switchPath(rootState), animation: .default)
      }

      // MARK: - Login

    case .path(.login(.loginResponse(.success(let response), _))):
      userData.accessToken.value = response.accessToken
      userData.refreshToken.value = response.refreshToken

      return .run { [linkedFlag = response.linkedFlag] send in
        do {
          let profile = try await lovebirdApi.fetchProfile()
          userData.profile.value = profile

          if linkedFlag == true {
            return await send(.switchPath(.mainTab(.init())))
          } else {
            return await send(.switchPath(.coupleLink(.init())))
          }
        } catch {
          print("FetchProfile Error: \(error)")
        }
      }

    case .path(.login(.loginResponse(.failure, let auth))):
      return .send(.switchPath(.onboarding(.init(auth: auth))))

      // MARK: - Onboarding

    case .path(.onboarding(.signUpResponse(.success(let response)))):
      userData.accessToken.value = response.accessToken
      userData.refreshToken.value = response.refreshToken

      return .run { send in
        do {
          let profile = try await lovebirdApi.fetchProfile()
          userData.profile.value = profile

          await send(.switchPath(.coupleLink(.init())))
        } catch {
          print("FetchProfile Error: \(error)")
        }
      }

      // MARK: - CoupleLink

    case .path(.coupleLink(.successToLink)):
      userData.mode.value = .couple
      return .send(.switchPath(.mainTab(.init())))

    case .path(.coupleLink(.skipTapped)):
      userData.mode.value = .single
      return .send(.switchPath(.mainTab(.init())))

      // MARK: - My Page

    case let .path(.mainTab(.path(.element(id: _, action: .myPageProfileEdit(.delegate(action)))))):
      switch action {
      case .logout, .withdrawal:
        userData.reset()
        return .send(.switchPath(.login(.init())))
      }

    case .path(.mainTab(.myPage(.mypageLink(.successToLink)))):
      userData.mode.value = .couple
      return .send(.switchPath(.mainTab(.init())))

      // MARK: - Etc

    case .viewAppear:
      return .merge(
        .publisher {
          loadingController.$isLoading
            .receive(on: DispatchQueue.main)
            .map(Action.loadingVisible)
        },
        .publisher {
          alertController.$type
            .receive(on: DispatchQueue.main)
            .map(Action.alertTypeApplied)
        },
        .publisher {
          toastController.$message
            .receive(on: DispatchQueue.main)
            .map(Action.toastMessageApplied)
        }
      )

    case let .loadingVisible(visible):
      state.isLoading = visible
      return .none

    case let .alertTypeApplied(style):
      state.alertStyle = style?.content
      return .none

    case let .toastMessageApplied(message):
      state.toastMessage = message
      return .none

    case .negativeTapped:
      alertController.buttonClick.send(nil)
      alertController.type = nil
      return .none

    case .positiveTapped:
      alertController.buttonClick.send(alertController.type)
      alertController.type = nil
      return .none

    case let .switchPath(rootState):
      state.path = rootState
      return .none

    default:
      return .none
    }
  }
  
  // MARK: - Private Methods

  private func switchState(with profile: Profile?) -> Path.State {
    guard let profile else { return .login(LoginCore.State()) }
    if profile.partnerId.isNil, userData.mode.value == .none {
      return .coupleLink(CoupleLinkCore.State())
    } else {
      return .mainTab(MainTabCore.State())
    }
  }
}

// MARK: - Typealias

typealias RootAction = RootCore.Action
typealias RootState = RootCore.State
