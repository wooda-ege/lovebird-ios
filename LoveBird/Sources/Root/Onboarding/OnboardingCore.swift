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
struct OnboardingCore: ReducerProtocol {
  enum Constant {
    static let nicknamePageIdx = 0
    static let maxNicknameLength = 20
    static let minNicknameLength = 2
  }
  struct State: Equatable {
    // common
    var page: Page = .first()
    var pageState: Page.Onboarding = .email
    var emailTextFieldState: TextFieldState = .none
    var nicknameTextFieldState: TextFieldState = .none
    var showBottomSheet = false
    var skipPages: [Page.Onboarding] = []

    var canSkip: Bool {
      self.pageState.canSkip
    }

    // page1 - email
    var email: String = ""

    // page2 - nickname
    var nickname: String = ""

    // page3 - profile
    var profileImage: UIImage?

    // page4 - birthday
    var birth: SimpleDate = .init()

    // page5 - gender
    var gender: Gender? = nil

    // page6 - anniversary
    var anniversary: SimpleDate = .init()
  }
  enum Action: Equatable {
    // common
    case nextTapped
    case previousTapped
    case nextButtonTapped
    case skipTapped
    case showBottomSheet
    case hideBottomSheet
    case doneButtonTapped

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
    case skipbirth

    // page5 - gender
    case genderSelected(Gender)
    
    // page6 - anniversary
    case dateYearSelected(Int)
    case dateMonthSelected(Int)
    case dateDaySelected(Int)
    case anniversaryInitialized

    // Network
    case registerProfileResponse(TaskResult<Profile>)
  }
  @Dependency(\.apiClient) var apiClient
  @Dependency(\.userData) var userData
  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .nextTapped, .nextButtonTapped:
          UIApplication.shared.endEditing(true)
          self.handleNext(state: &state)
          return .none

      case .doneButtonTapped:
        return .run { [state = state] send in
          do {
            // 프로필 등록 - 생년월일 입력 뷰에서 다음 버튼 클릭시
            let profile = try await self.apiClient.request(
              .registerProfile(
                image: state.skipPages.contains(.profileImage) ? nil : state.profileImage,
                profileRequest: RegisterProfileRequest.init(
                  email: state.email,
                  nickname: state.nickname,
                  birthDay: state.skipPages.contains(.birth) ? nil : state.birth.toYMDFormat(),
                  firstDate: state.skipPages.contains(.anniversary) ? nil : state.anniversary.toYMDFormat(),
                  gender: state.gender?.rawValue ?? "UNKNOWN",
                  deviceToken: "fcm")
              )
            ) as Profile
            await send(.registerProfileResponse(.success(profile)))
          } catch {
            print("프로필 등록 실패")
          }
        }

      case .skipTapped:
        guard state.pageState != .anniversary else {
          state.skipPages.append(.anniversary)
          return .send(.doneButtonTapped)
        }

        UIApplication.shared.endEditing(true)
        self.handleSkip(state: &state)
        return .none

      case .previousTapped:
        UIApplication.shared.endEditing(true)
        if !state.page.isFisrt {
          state.page.update(.previous)
          state.pageState = state.page.state
        }
        return .none

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
        state.nickname = String(nickname.prefix(20))
        state.nicknameTextFieldState = !nickname.isNicknameValid ? .error(.nickname)
          : nickname.count >= 2 ? .correct(.nickname)
          : .editing(.nickname)
        return .none

      case .genderSelected(let gender):
        state.gender = gender
        return .none

      case .birthUpdated(let birth):
        state.birth = birth
        return .none

      case .dateYearSelected(let year):
        state.anniversary.year = year
        return .none

      case .dateMonthSelected(let month):
        state.anniversary.month = month
        return .none

      case .dateDaySelected(let day):
        state.anniversary.day = day
        return .none

      case .showBottomSheet:
        state.showBottomSheet = true
        return .none

      case .hideBottomSheet:
        state.showBottomSheet = false
        return .none

      case .birthInitialized:
        state.birth = .init()
        return .none

      case .anniversaryInitialized:
        state.anniversary = .init()
        return .none

      case .imageSelected(let image):
        state.profileImage = image
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
      state.page.update(.next)

    case .nickname:
      guard state.nicknameTextFieldState.isCorrect else { return }
      state.page.update(.next)

    case .profileImage:
      guard state.profileImage != nil else { return }
      state.page.update(.next)

    case .gender, .birth:
      state.page.update(.next)

    case .anniversary:
      return
    }

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
