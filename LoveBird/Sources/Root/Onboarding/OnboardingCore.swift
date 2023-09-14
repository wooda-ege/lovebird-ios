//
//  OnboardingCore.swift
//  wooda
//
//  Created by 황득연 on 2023/05/09.
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
    var buttonClickState: ButtonClickState = .notClicked
    var showBottomSheet = false

    // page1 - email
    var email: String = ""

    // page2 - nickname
    var nickname: String = ""

    // page3 - profile
    var profileImage: UIImage?

    // page4 - birthday
    var birthday: String? = ""
    var birthdateYear: Int = Date().year
    var birthdateMonth: Int = Date().month
    var birthdateDay: Int = Date().day

    // page5 - gender
    var gender = ""

    // page6 - anniversary
    var firstday: String? = ""
    var firstdateYear: Int = Date().year
    var firstdateMonth: Int = Date().month
    var firstdateDay: Int = Date().day

    var invitationCode: String = "임시코드임니다"
    var invitationInputCode: String = ""
  }
  
  enum Action: Equatable {
    // common
    case nextTapped
    case previousTapped
    case nextButtonTapped
    case showBottomSheet
    case hideBottomSheet
    case doneButtonTapped

    // page1 - email
    case emailTextFieldStateChanged(TextFieldState)
    case emailEdited(String)

    // page2 - nickname
    case nicknameTextFieldStateChanged(TextFieldState)
    case nicknameEdited(String)

    // page3 - profile

    // page4 - birthday
    case birthdateYearSelected(Int)
    case birthdateMonthSelected(Int)
    case birthdateDaySelected(Int)
    case birthdateInitialied
    case skipBirthdate

    // page5 - gender
    case genderSelected(String)

    // page6 - anniversary
    case dateYearSelected(Int)
    case dateMonthSelected(Int)
    case dateDaySelected(Int)
    case dateInitialied
    case registerProfileResponse(TaskResult<Profile>)
    case tryLinkResponse(TaskResult<TryLinkResponse>)
    case imageSelected(UIImage?)
    case selectBirthDate
    case skipFisrtdate
    case selectFirstDate
    case none
  }
  
  @Dependency(\.apiClient) var apiClient
  @Dependency(\.userData) var userData
  
  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .nextTapped, .nextButtonTapped:
        self.handleNext(state: &state)
        UIApplication.shared.endEditing(true)
        return .none

      case .previousTapped:
        if !state.page.isFisrt {
          state.page.update(.previous)
          state.pageState = state.page.state
        }
        UIApplication.shared.endEditing(true)
        return .none

      case .emailTextFieldStateChanged(let textFieldState):
        state.emailTextFieldState = textFieldState
        return .none

      case .emailEdited(let email):
        state.email = email
        if email.isEmailValid {
          state.emailTextFieldState = .correct(.email)
        } else if email.isEmpty {
          state.emailTextFieldState = .editing(.email)
        } else {
          state.emailTextFieldState = .error(.email)
        }
        return .none

      case .nicknameEdited(let nickname):
        state.nickname = String(nickname.prefix(20))
        if nickname.isNicknameValid {
          state.nicknameTextFieldState = nickname.count >= 2 ? .correct(.nickname) : .editing(.nickname)
        } else {
          state.nicknameTextFieldState = .error(.nickname)
        }
        return .none

      case .genderSelected(let gender):
        state.gender = gender
        state.buttonClickState = .clicked
        return .none

      case .birthdateYearSelected(let year):
        state.birthdateYear = year
        return .none

      case .birthdateMonthSelected(let month):
        state.birthdateMonth = month
        return .none

      case .birthdateDaySelected(let day):
        state.birthdateDay = day
        return .none

      case .dateYearSelected(let year):
        state.firstdateYear = year
        return .none

      case .dateMonthSelected(let month):
        state.firstdateMonth = month
        return .none

      case .dateDaySelected(let day):
        state.firstdateDay = day
        return .none

      case .showBottomSheet:
        state.showBottomSheet = true
        return .none

      case .hideBottomSheet:
        state.showBottomSheet = false
        return .none

      case .birthdateInitialied:
        state.birthdateYear = Date().year
        state.birthdateMonth = Date().month
        state.birthdateDay = Date().day
        return .none

      case .dateInitialied:
        state.firstdateYear = Date().year
        state.firstdateMonth = Date().month
        state.firstdateDay = Date().day
        return .none

      case .imageSelected(let image):
        state.profileImage = image
        return .none
        
      case .skipBirthdate:
        state.page.update(.next)
        state.birthday = nil
        return .none
        
      case .selectBirthDate:
        let birthyear = state.birthdateYear
        let birthmonth = state.birthdateMonth
        let birthday = state.birthdateDay

        state.page.update(.next)
        state.birthday = String(format: "%04d-%02d-%02d", birthyear, birthmonth, birthday)
        return .none
        
      case .skipFisrtdate:
        state.firstday = nil
        
        return .run { [state = state] send in
          do {
            // 프로필 등록 - 생년월일 입력 뷰에서 다음 버튼 클릭시
            let profile = try await self.apiClient.request(
              .registerProfile(
                image: state.profileImage,
                profileRequest: RegisterProfileRequest.init(
                  email: state.email,
                  nickname: state.nickname,
                  birthDay: state.birthday,
                  firstDate: state.firstday,
                  gender: state.gender,
                  deviceToken: "fcm")
              )
            ) as Profile
            
            await send(.registerProfileResponse(.success(profile)))
          } catch {
            print("프로필 등록 실패")
          }
        }
        
      case .doneButtonTapped:
        let firstyear = state.firstdateYear
        let firstmonth = state.firstdateMonth
        let firstday = state.firstdateDay
        state.firstday = String(format: "%04d-%02d-%02d", firstyear, firstmonth, firstday)
        
        return .run { [state = state] send in
          do {
            // 프로필 등록 - 생년월일 입력 뷰에서 다음 버튼 클릭시
            let profile = try await self.apiClient.request(
              .registerProfile(
                image: state.profileImage,
                profileRequest: RegisterProfileRequest.init(
                  email: state.email,
                  nickname: state.nickname,
                  birthDay: state.birthday,
                  firstDate: state.firstday,
                  gender: state.gender,
                  deviceToken: "fcm")
              )
            ) as Profile
            
            await send(.registerProfileResponse(.success(profile)))
          } catch {
            print("프로필 등록 실패")
          }
        }

      default:
        return .none
      }
    }
  }

  private func handleNext(state: inout State) {
    switch state.pageState {
    case .email:
      guard state.emailTextFieldState.isCorrect else { return }
      state.page.update(.next)

    case .nickname:
      guard state.nicknameTextFieldState.isCorrect else { return }
      state.page.update(.next)

    case .profileImage, .gender, .birth:
      state.page.update(.next)
    default:
      return
    }
    state.pageState = state.page.state
  }
}
