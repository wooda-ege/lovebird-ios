//
// OnboardingCore.swift
// wooda
//
// Created by 황득연 on 2023/05/09.
//
import ComposableArchitecture
import SwiftUIPager
import Foundation
import SwiftUI
import UIKit

typealias OnboardingState = OnboardingCore.State
typealias OnboardingAction = OnboardingCore.Action

struct OnboardingCore: Reducer {

  enum Constant {
    static let nicknamePageIdx = 0
    static let maxNicknameLength = 20
    static let minNicknameLength = 2
  }
  
  struct State: Equatable {
    init(auth: Authenticate) {
      self.auth = auth
      self.pageState = auth.provider == .apple ? .nickname : .email
      if auth.provider == .apple {
        self.page.update(.next)
      }
    }
    
    // common
    let auth: Authenticate
    var page: Page = .first()
    var pageState: Page.Onboarding
    var emailTextFieldState: TextFieldState = .none
    var nicknameTextFieldState: TextFieldState = .none

    var skipPages: [Page.Onboarding] = []
    
    var canSkip: Bool {
      self.pageState.canSkip
    }

    var email: String = ""

    // page2 - nickname
    var nickname: String = ""

    // page3 - profile
    var profileImage: UIImage?

    // page4 - birthday
    var birth: SimpleDate = .init()
    var shouldShowBirthdayPickerView = false

    // page5 - gender
    var gender: Gender? = nil

    // page6 - firstDate
    var firstDate: SimpleDate = .init()
    var shouldShowFirstDatePickerView = false
  }

  enum Action: Equatable {
    // common
    case nextTapped
    case previousTapped
    case nextButtonTapped
    case skipTapped
    case doneButtonTapped
    case flush

    // page1 - email
    case emailFocusFlashed
    case emailEdited(String)
    
    // page2 - nickname
    case nicknameFocusFlashed
    case nicknameEdited(String)

    // page3 - profile
    case imageSelected(UIImage?)

    // page4 - birthday
    case birthInitialized
    case birthUpdated(SimpleDate)
    case birthdayPickerViewVisible(Bool)
    case skipbirth

    // page5 - gender
    case genderSelected(Gender)
    
    // page6 - firstDate
    case firstDateInitialized
    case firstDateUpdated(SimpleDate)
    case firstDatePickerViewVisible(Bool)

    // Network
    case signUpResponse(TaskResult<Token>)
  }

  @Dependency(\.lovebirdApi) var lovebirdApi
  @Dependency(\.userData) var userData

  var body: some Reducer<State, Action> {
    Reduce {
      state,
      action in
      switch action {
      case .nextTapped,
          .nextButtonTapped:
        self.handleNext(state: &state)
        return .send(.flush)
        
      case .doneButtonTapped:
        return .run { [state] send in
          do {
            // 프로필 등록 - 생년월일 입력 뷰에서 다음 버튼 클릭시
            let image = state.skipPages.contains(.profileImage) ? nil : state.profileImage
            let authRequest = Authenticate(provider: state.auth.provider, idToken: state.auth.idToken)
            let profileRequest = AddProfileRequest(
              email: state.email.isEmpty ? nil : state.email,
              nickname: state.nickname,
              birthDay: state.skipPages.contains(.birth) ? nil : state.birth.toYMDFormat(),
              firstDate: state.skipPages.contains(.firstDate) ? nil : state.firstDate.toYMDFormat(),
              gender: state.gender?.rawValue ?? "UNKNOWN",
              deviceToken: "fcm"
            )
            
            let profile = try await lovebirdApi.signUp(
              image: image?.pngData(),
              auth: authRequest,
              profile: profileRequest
            )
            await send(.signUpResponse(.success(profile)))
          } catch {
            print("프로필 등록 실패")
          }
        }

      case .skipTapped:
        guard state.pageState != .firstDate else {
          state.skipPages.append(.firstDate)
          return .send(.doneButtonTapped)
        }

        self.handleSkip(state: &state)
        return .send(.flush)
        
      case .previousTapped:
        if !state.page.isFisrt && !(state.auth.provider == .apple && state.page.index == 1)  {
          state.page.update(.previous)
          state.pageState = state.page.state
        }
        return .send(.flush)
        
      case .emailFocusFlashed:
        state.emailTextFieldState = .none
        return .none
        
      case .emailEdited(let email):
        state.email = email
        state.emailTextFieldState = email.isEmailValid ? .correct(.email)
        : email.isEmpty ? .editing(.email)
        : .error(.email)
        return .none
        
      case .nicknameFocusFlashed:
        state.nicknameTextFieldState = .none
        return .none

      case .nicknameEdited(let nickname):
        state.nickname = String(nickname.prefix(13))
        state.nicknameTextFieldState = !nickname.isNicknameValid ? .error(.nickname)
        : nickname.count >= 2 ? .correct(.nickname)
        : .editing(.nickname)
        return .none

      case .imageSelected(let image):
        state.profileImage = image
        return .none

      case .birthUpdated(let birth):
        state.birth = birth
        return .none

      case .birthInitialized:
        state.birth = .init()
        return .none

      case .genderSelected(let gender):
        state.gender = gender
        return .none

      case .firstDateInitialized:
        state.firstDate = .init()
        return .none

      case .firstDateUpdated(let firstDate):
        state.firstDate = firstDate
        return .none

      case .birthdayPickerViewVisible(let visible):
        state.shouldShowBirthdayPickerView = visible
        return .none

      case .firstDatePickerViewVisible(let visible):
        state.shouldShowFirstDatePickerView = visible
        return .none

      case .flush:
        UIApplication.shared.endEditing(true)
        state.shouldShowBirthdayPickerView = false
        state.shouldShowFirstDatePickerView = false
        return .none

      default:
        return .none
      }
    }
  }
  // MARK: - Private Method
  private func handleNext(state: inout State) {
    switch state.pageState {
    case .email:
      guard state.emailTextFieldState.isCorrect else { return }
    case .nickname:
      guard state.nicknameTextFieldState.isCorrect else { return }

    case .profileImage:
      guard state.profileImage != nil else { return }

    case .gender:
      guard state.gender != nil else { return }

    case .birth:
      break

    case .firstDate:
      return
    }

    state.page.update(.next)
    state.pageState = state.page.state
  }

  private func handleSkip(state: inout State) {
    switch state.pageState {
    case .profileImage, .birth, .gender:
      if !state.skipPages.contains(state.pageState) {
        state.skipPages.append(state.pageState)
      }
      state.page.update(.next)
      state.pageState = state.page.state

    default:
      return
    }
  }
}
