//
//  MyPageProfileEditCore.swift
//  LoveBird
//
//  Created by 황득연 on 2023/08/13.
//

import UIKit
import ComposableArchitecture

typealias MyPageProfileEditState = MyPageProfileEditCore.State
typealias MyPageProfileEditAction = MyPageProfileEditCore.Action

struct MyPageProfileEditCore: Reducer {

  enum FocusedType {
    case nickname
    case email
    case none
  }
  
  struct State: Equatable {
    var profile: Profile
    var nickname = ""
    var email = ""
    var nicknameTextFieldState: TextFieldState = .none
    var emailTextFieldState: TextFieldState = .none
    var annivarsary: SimpleDate = .init()
    var birthdate: SimpleDate = .init()
    var isNicknameFocused = false
    var isEmailFocused = false

  }
  
  enum Action: Equatable {
    case viewAppear
    case backTapped
    case isFocused(FocusedType)
    
    case nicknameEdited(String)
    case emailEdited(String)
    
    case profileEditTapped
    case annivarsaryEditTapped
    case logoutTapped
    case withdrawalTapped
    case alertButtonTapped(AlertController.Style.`Type`?)
    case withdrawal
    case logout

    case editProfileResponse(TaskResult<Profile>)
    case withdrawalResponse(TaskResult<Empty>)

    case delegate(Delegate)
    enum Delegate: Equatable {
      case logout
      case withdrawal
    }
  }
  
  @Dependency(\.lovebirdApi) var lovebirdApi
  @Dependency(\.userData) var userData
  @Dependency(\.alertController) var alertController

  @Dependency(\.dismiss) var dismiss

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {

      case .backTapped:
        return .run { _ in await dismiss() }

      case .isFocused(let type):
        state.isNicknameFocused = type == .nickname
        state.isEmailFocused = type == .email
        return .none

      case .nicknameEdited(let nickname):
        let nickname = String(nickname.prefix(13))
        state.nickname = nickname
        state.nicknameTextFieldState = TextFieldState.updateState(nickname: nickname)
        return .none

      case .emailEdited(let email):
        state.email = email
        state.emailTextFieldState = TextFieldState.updateState(email: email)
        return .none

      case .profileEditTapped:
        let nickname: String?
        if case .correct = state.nicknameTextFieldState { nickname = state.nickname }
        else if state.nickname.isEmpty { nickname = state.profile.nickname }
        else { nickname = nil }

        let email: String?
        if case .correct = state.emailTextFieldState { email = state.email }
        else if state.email.isEmpty { email = state.profile.email }
        else { email = nil }

        guard let nickname, let email else { return .none }
        let request = EditProfileRequest(nickname: nickname, email: email)

        return .run { send in
          await send(
            .editProfileResponse(
              await TaskResult {
                try await lovebirdApi.editProfile(profile: request)
              }
            )
          )
        }

      case .logoutTapped:
        alertController.showAlert(type: .logout)
        return .publisher {
          alertController.buttonClick
            .map(Action.alertButtonTapped)
        }

      case .withdrawalTapped:
        alertController.showAlert(type: .withdrawal)
        return .publisher {
          alertController.buttonClick
            .map(Action.alertButtonTapped)
        }
        
      case let .alertButtonTapped(type):
        switch type {
        case .logout:
          return .send(.logout)

        case .withdrawal:
          return .send(.withdrawal)

        default:
          return .none
        }

      case .logout:
        return .send(.delegate(.logout))

      case .withdrawal:
        return .run { send in
          await send(
            .withdrawalResponse(
              await TaskResult {
                try await lovebirdApi.withdrawal()
              }
            )
          )
        }

      case .editProfileResponse(.success(let profile)):
        userData.profile.value = profile
        return .run { _ in await dismiss() }

      case .withdrawalResponse(.success):
        return .send(.delegate(.withdrawal))

      default:
        return .none
      }
    }
  }
}
