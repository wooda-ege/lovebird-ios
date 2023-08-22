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
    var page: Page = .first()
    var pageIdx: Int = Constant.nicknamePageIdx
    var nickname: String = ""
    var textFieldState: TextFieldState = .none
    var buttonClickState: ButtonClickState = .notClicked
    var showBottomSheet = false
    var gender = ""
    var birthdateYear: Int = Date().year
    var birthdateMonth: Int = Date().month
    var birthdateDay: Int = Date().day
    var birthday: String? = ""
    var firstdateYear: Int = Date().year
    var firstdateMonth: Int = Date().month
    var firstdateDay: Int = Date().day
    var email: String = ""
    var invitationCode: String = "임시코드임니다"
    var invitationInputCode: String = ""
    var profileImage: UIImage?
  }
  
  enum Action: Equatable {
    case nextTapped
    case previousTapped
    case nextButtonTapped
    case textFieldStateChanged(TextFieldState)
    case genderSelected(String)
    case birthdateYearSelected(Int)
    case birthdateMonthSelected(Int)
    case birthdateDaySelected(Int)
    case dateYearSelected(Int)
    case dateMonthSelected(Int)
    case dateDaySelected(Int)
    case nicknameEdited(String)
    case emailEdited(String)
    case doneButtonTapped
    case showBottomSheet
    case hideBottomSheet
    case dateInitialied
    case birthdateInitialied
    case registerProfileResponse(TaskResult<Profile>)
    case tryLinkResponse(TaskResult<TryLinkResponse>)
    case imageSelected(UIImage?)
    case circleClicked(Int)
    case invitationcodeEdited(String)
    case invitationViewLoaded(String)
    case tryLink(String)
    case skipBirthdate
    case selectBirthDate
    case none
  }
  
  @Dependency(\.apiClient) var apiClient
  @Dependency(\.userData) var userData
  
  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .circleClicked(let index):
        state.page.update(.move(increment: index))
        return .none

      case .nextTapped, .nextButtonTapped:
        state.page.update(.next)
        state.pageIdx = 1
        return .none

      case .textFieldStateChanged(let textFieldState):
        state.textFieldState = textFieldState
        return .none

      case .previousTapped:
        if state.page.index == 0 {
          return .none
        } else {
          state.page.update(.previous)
        }
        return .none

      case .nicknameEdited(let nickname):
        state.nickname = String(nickname.prefix(20))
        if nickname.isNicknameValid {
          state.textFieldState = nickname.count >= 2 ? .nicknameCorrect : .editing
        } else {
          state.textFieldState = .error
        }
        return .none

      case .emailEdited(let email):
        state.email = email
        if email.isEmailValid {
          state.textFieldState = email.count >= 2 ? .emailCorrect : .editing
        } else {
          state.textFieldState = .emailError
        }
        return .none

      case .invitationcodeEdited(let code):
        state.invitationInputCode = code
        return .none

      case .invitationViewLoaded(let code):
        state.invitationCode = code
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
        state.pageIdx = 1
        state.birthday = nil
        state.birthdateDay = 00
        state.birthdateMonth = 00
        state.birthdateYear = 0000
        return .none
        
      case .selectBirthDate:
        let birthyear = state.birthdateYear
        let birthmonth = state.birthdateMonth
        let birthday = state.birthdateDay

        state.page.update(.next)
        state.pageIdx = 1
        state.birthday = String(format: "%04d-%02d-%02d", birthyear, birthmonth, birthday)
        return .none
        
      case .doneButtonTapped:
        return .run { [state = state] send in
          do {
            let firstyear = state.firstdateYear
            let firstmonth = state.firstdateMonth
            let firstday = state.firstdateDay
            let firstDate = String(format: "%04d-%02d-%02d", firstyear, firstmonth, firstday)
            // 프로필 등록 - 생년월일 입력 뷰에서 다음 버튼 클릭시
            let profile = try await self.apiClient.request(
              .registerProfile(
                image: state.profileImage,
                profileRequest: RegisterProfileRequest.init(
                  email: state.email,
                  nickname: state.nickname,
                  birthDay: state.birthday,
                  firstDate: firstDate,
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
}

extension Page: Equatable {
  public static func == (lhs: Page, rhs: Page) -> Bool {
    lhs.index == rhs.index
  }
}
