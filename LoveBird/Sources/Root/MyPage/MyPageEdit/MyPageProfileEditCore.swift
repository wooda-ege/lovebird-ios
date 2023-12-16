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
  enum CurrentState {
    case annivarsary
    case birthdate
  }

  enum FocusedType {
    case nickname
    case email
    case annivarsary
    case birthdate
    case none
  }
  
  struct State: Equatable {
    var profile: Profile?
    var nickname = ""
    var email = ""
    var annivarsary: SimpleDate = .init()
    var birthdate: SimpleDate = .init()
    var isNicknameFocused = false
    var isEmailFocused = false
    var isAnnivarsaryFocused = false
    var isBirthdateFocused = false
    
    var showBottomSheet = false
    var currentState: CurrentState = .annivarsary
  }
  
  enum Action: Equatable {
    case viewAppear
    case backTapped
    case isFocused(FocusedType)
    
    case nicknameEdited(String)
    case emailEdited(String)
    case annivarsaryEdited(SimpleDate)
    case birthdateEdited(SimpleDate)
    
    case profileEditTapped
    case annivarsaryEditTapped
    case withdrawalTapped

    case editProfileResponse(TaskResult<Profile>)
    case withdrawalResponse(TaskResult<String>)
    
    case showBottomSheet
    case hideBottomSheet
    
    case annivarsaryUpdated(SimpleDate)
    case birthdateUpdated(SimpleDate)
    case anniversaryInitialized
    case birthdateInitialized
    case changeCurrentState(CurrentState)

    case delegate(Delegate)
    enum Delegate: Equatable {
      case withdrawal
    }
  }
  
  @Dependency(\.lovebirdApi) var lovebirdApi
  @Dependency(\.userData) var userData

  @Dependency(\.dismiss) var dismiss

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {

      case .backTapped:
        return .run { _ in await dismiss() }

      case .isFocused(let type):
        state.isNicknameFocused = type == .nickname
        state.isEmailFocused = type == .email
        state.isAnnivarsaryFocused = type == .annivarsary
        state.isBirthdateFocused = type == .birthdate
        return .none

      case .nicknameEdited(let nickname):
        state.nickname = nickname
        return .none

      case .emailEdited(let email):
        state.email = email
        return .none

      case .annivarsaryEdited(let annivarsary):
        state.annivarsary = annivarsary
        return .none

      case .birthdateEdited(let birthdate):
        state.birthdate = birthdate
        return .none

      case .annivarsaryEditTapped:
        let request: EditProfileAnnivarsaryRequest = .init(
          annivarsary: state.annivarsary.toYMDFormat(),
          birthdate: state.birthdate.toYMDFormat()
        )

        return .run { send in
          await send(
            .editProfileResponse(
              await TaskResult {
                try await lovebirdApi.editProfileAnnivarsary(image: nil, profile: request)
              }
            )
          )
        }

      case .profileEditTapped:
        let request: EditProfileRequest = .init(
          nickname: state.nickname,
          email: state.email
        )

        return .run { send in
          await send(
            .editProfileResponse(
              await TaskResult {
                try await lovebirdApi.editProfile(image: nil, profile: request)
              }
            )
          )
        }

      case .withdrawalTapped:
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
        self.userData.store(key: .user, value: profile)
        return .run { _ in await dismiss() }

      case .withdrawalResponse(.success):
        return .send(.delegate(.withdrawal))

      case .showBottomSheet:
        state.showBottomSheet = true
        return .none

      case .hideBottomSheet:
        state.showBottomSheet = false
        return .none

      case .annivarsaryUpdated(let date):
        state.annivarsary = date
        return .none

      case .birthdateUpdated(let date):
        state.birthdate = date
        return .none

      case .anniversaryInitialized:
        state.annivarsary = .init()
        return .none

      case .birthdateInitialized:
        state.birthdate = .init()
        return .none

      case .changeCurrentState(let currentState):
        state.currentState = currentState
        return .none

      default:
        return .none
      }
    }
  }
}
