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
    var image: Data?
    var profile: Profile?
    var nickname = ""
    var email = ""
    var isNicknameFocused = false
    var isEmailFocused = false
    var isImagePickerPresented = false
    var selectedImage: UIImage? = nil
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
    case presentImagePicker
    case dismissImagePicker
    case imageSelected(UIImage?)
    case imagePicker(PresentationAction<ImagePickerCore.Action>)
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
        state.imagePicker = ImagePickerCore.State()
      case .presentImagePicker:
        state.imagePicker = ImagePickerCore.State()
      case .dismissImagePicker:
        state.imagePicker = nil
      case .imageSelected(let image):
        state.selectedImage = image
        state.isImagePickerPresented = false
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
    .ifLet(\.$imagePicker, action: /Action.imagePicker) {
      ImagePickerCore()
    }
  }
}
