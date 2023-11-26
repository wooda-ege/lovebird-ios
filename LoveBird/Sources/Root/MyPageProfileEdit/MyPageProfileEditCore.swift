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
    var profile: Profile?
    var nickname = ""
    var email = ""
    var isNicknameFocused = false
    var isEmailFocused = false
  }

  enum Action: Equatable {
    case viewAppear
    case backTapped
    case isFocused(FocusedType)
    case nicknameEdited(String)
    case emailEdited(String)
    case editTapped
    case withdrawalTapped
    case editProfileResponse(TaskResult<Profile>)
    case withdrawalResponse(TaskResult<String>)

    case delegate(Delegate)
    enum Delegate: Equatable {
      case withdrawal
    }
  }

  @Dependency(\.apiClient) var apiClient
  @Dependency(\.dismiss) var dismiss
  @Dependency(\.userData) var userData

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .viewAppear:
        let profile = self.userData.get(key: .user, type: Profile.self)
        if let profile { state.profile = profile }
        return .none

      case .backTapped:
        return .run { _ in await dismiss() }

      case .isFocused(let type):
        state.isNicknameFocused = type == .nickname
        state.isEmailFocused = type == .email
        return .none

      case .nicknameEdited(let nickname):
        state.nickname = nickname
        return .none

      case .emailEdited(let email):
        state.email = email
        return .none

      case .editTapped:
        if state.nickname.isEmpty || state.email.isEmpty { return .none }
        
        let request: EditProfileRequest = .init(
          nickname: state.nickname,
          email: state.email
        )
				return .run { send in
					await send(
						.editProfileResponse(
							await TaskResult {
								try await (self.apiClient.request(.editProfile(image: nil, editProfile: request))) as Profile
							}
						)
					)
				}

      case .withdrawalTapped:
				return .run { send in
					await send(
						.withdrawalResponse(
							await TaskResult {
								try await (self.apiClient.requestRaw(.withdrawal))
							}
						)
					)
				}

      case .editProfileResponse(.success(let profile)):
        self.userData.store(key: .user, value: profile)
        return .run { _ in await dismiss() }

      case .withdrawalResponse(.success):
        return .send(.delegate(.withdrawal))

      default:
        return .none
      }
    }
  }
}
