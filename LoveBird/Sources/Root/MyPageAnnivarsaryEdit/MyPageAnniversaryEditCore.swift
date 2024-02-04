//
//  MyPageAnniversaryEditCore.swift
//  LoveBird
//
//  Created by 황득연 on 2/3/24.
//

import Foundation
import ComposableArchitecture

struct MyPageAnniversaryEditCore: Reducer {

  // MARK: - State

  struct State: Equatable {
    enum CurrentState {
      case firstDate
      case birthday
      case none
    }

    init(profile: Profile) {
      self.profile = profile
      self.firstDate = SimpleDate(date: profile.firstDate?.toDate())
      self.birthday = SimpleDate(date: profile.birthDay?.toDate())
    }

    let profile: Profile
    var firstDate: SimpleDate
    var birthday: SimpleDate
    var isAnniversaryFocused = false
    var isBirthdateFocused = false

    var shouldShowFirstDatePickerView = false
    var shouldShowBirthdayPickerView = false
    var currentState: CurrentState = .none

  }

  // MARK: - Action

  enum Action: Equatable {
    case backTapped
    case editTapped
    case firstDateTapped
    case birthdayTapped
    case firstDatePickerViewVisible(Bool)
    case birthdayPickerViewVisible(Bool)

    case firstDateUpdated(SimpleDate)
    case birthdayUpdated(SimpleDate)
    case firstDateInitialized
    case birthdayInitialized
    case changeCurrentState(State.CurrentState)

    case editProfileResponse(TaskResult<Profile>)

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

      case .editTapped:
        let request: EditProfileRequest = .init(
          firstDate: state.firstDate.toYMDFormat(),
          birthday: state.birthday.toYMDFormat()
        )

        return .run { send in
          await send(
            .editProfileResponse(
              await TaskResult {
                try await lovebirdApi.editProfile(profile: request)
              }
            )
          )
        }

      case .firstDateTapped:
        state.currentState = .firstDate
        state.shouldShowBirthdayPickerView = false
        state.shouldShowFirstDatePickerView = true
        return .none

      case .birthdayTapped:
        state.currentState = .birthday
        state.shouldShowBirthdayPickerView = true
        state.shouldShowFirstDatePickerView = false
        return .none
        
      case .firstDatePickerViewVisible(let visible):
        state.shouldShowFirstDatePickerView = visible
        return .none

      case .birthdayPickerViewVisible(let visible):
        state.shouldShowBirthdayPickerView = visible
        return .none

      case .firstDateUpdated(let date):
        state.firstDate = date
        return .none

      case .birthdayUpdated(let date):
        state.birthday = date
        return .none

      case .firstDateInitialized:
        state.firstDate = SimpleDate(date: state.profile.firstDate?.toDate())
        return .none

      case .birthdayInitialized:
        state.birthday = SimpleDate(date: state.profile.birthDay?.toDate())
        return .none
        
      case .changeCurrentState(let currentState):
        state.currentState = currentState
        return .none

      case .editProfileResponse(.success(let profile)):
        self.userData.store(key: .user, value: profile)
        return .run { _ in await dismiss() }

      default:
        return .none
      }
    }
  }
}

typealias MyPageAnniversaryEditState = MyPageAnniversaryEditCore.State
typealias MyPageAnniversaryEditAction = MyPageAnniversaryEditCore.Action

