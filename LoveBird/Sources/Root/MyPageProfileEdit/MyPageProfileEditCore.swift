//
//  MyPageProfileEditCore.swift
//  LoveBird
//
//  Created by 황득연 on 2023/08/13.
//

import Foundation
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
    @BindingState var isImagePickerPresented = false
    var image: Data?
    var profile: Profile?
    var nickname = ""
    var email = ""
    var isNicknameFocused = false
    var isEmailFocused = false
    var isImagePickerVisible = false
  }

  enum Action: Equatable {
    case viewAppear
    case backButtonTapped
    case imageTapped
    case isFocused(FocusedType)
    case nicknameEdited(String)
    case emailEdited(String)
    case editTapped
    case editProfileResponse(TaskResult<Profile>)
    case imagePickerVisible(Bool)
  }

  @Dependency(\.apiClient) var apiClient
  @Dependency(\.userData) var userData

  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .viewAppear:
        let profile = self.userData.get(key: .user, type: Profile.self)
        if let profile {
          state.profile = profile
        }
      case .isFocused(let type):
        state.isNicknameFocused = type == .nickname
        state.isEmailFocused = type == .email
      case .nicknameEdited(let nickname):
        state.nickname = nickname
      case .emailEdited(let email):
        state.email = email
      case .imageTapped:
        state.isImagePickerPresented = true
      case .imagePickerVisible(let visible):
        state.isImagePickerVisible = visible
      // Network
      case .editTapped:
        let request: EditProfileRequest = .init(
          image: state.image,
          nickname: state.nickname.isEmpty ? nil : state.nickname,
          email: state.email.isEmpty ? nil : state.email
        )
        return .task {
          .editProfileResponse(
            await TaskResult {
              try await (self.apiClient.request(.editProfile(editProfile: request))) as Profile
            }
          )
        }
      default:
        break
      }
      return .none
    }
  }
}
