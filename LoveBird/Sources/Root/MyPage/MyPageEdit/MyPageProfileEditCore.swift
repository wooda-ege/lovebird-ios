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
    case backButtonTapped
    case isFocused(FocusedType)
    
    case nicknameEdited(String)
    case emailEdited(String)
    case annivarsaryEdited(SimpleDate)
    case birthdateEdited(SimpleDate)
    
    case profileEditTapped
    case annivarsaryEditTapped
    
    case withdrawal
    case editProfileResponse(TaskResult<Profile>)
    case withdrawalResponse(TaskResult<String>)
    
    case showBottomSheet
    case hideBottomSheet
    
    case annivarsaryUpdated(SimpleDate)
    case birthdateUpdated(SimpleDate)
    case anniversaryInitialized
    case birthdateInitialized
    case changeCurrentState(CurrentState)
  }
  
  @Dependency(\.apiClient) var apiClient
  @Dependency(\.userData) var userData
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .viewAppear:
        let profile = self.userData.get(key: .user, type: Profile.self)
        if let profile { state.profile = profile }
        return .none
        
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
                try await (self.apiClient.request(.editProfileAnnivarsary(
                  image: nil,
                  editProfile: request)
                )) as Profile
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
                try await (self.apiClient.request(.editProfile(
                  image: nil,
                  editProfile: request)
                )) as Profile
              }
            )
          )
        }
        
      case .withdrawal:
        return .run { send in
          await send(
            .withdrawalResponse(
              await TaskResult {
                try await (self.apiClient.requestRaw(.withdrawal))
              }
            )
          )
        }
        
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
