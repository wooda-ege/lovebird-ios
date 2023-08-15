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

struct MyPageProfileEditCore: ReducerProtocol {

  enum FocusedType {
    case nickname
    case email
    case none
  }

  struct State: Equatable {
    @PresentationState var imagePicker: ImagePickerCore.State?
    var profile: Profile?
    var nickname = ""
    var email = ""
    var isNicknameFocused = false
    var isEmailFocused = false
  }

  enum Action: Equatable {
    case viewAppear
    case backButtonTapped
    case isFocused(FocusedType)
    case nicknameEdited(String)
    case emailEdited(String)
    case editTapped
    case editProfileResponse(TaskResult<Profile>)
  }

  @Dependency(\.apiClient) var apiClient
  @Dependency(\.userData) var userData

  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .viewAppear:
        let profile = self.userData.get(key: .user, type: Profile.self)
        if let profile { state.profile = profile }
        return .none

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
        let request: EditProfileRequest = .init(
          image: nil,
          nickname: state.nickname,
          email: state.email
        )
        return .task {
          .editProfileResponse(
            await TaskResult {
              try await (self.apiClient.request(.editProfile(editProfile: request))) as Profile
            }
          )
        }

      default:
        return .none
      }
    }
  }
}
