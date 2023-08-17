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
    
    init(accessToken: String = "", refreshToken: String = "") {
      self.accessToken = accessToken
      self.refreshToken = refreshToken
    }
    
    var accessToken: String = ""
    var refreshToken: String = ""
    
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
    case none
  }
  
  @Dependency(\.apiClient) var apiClient
  
  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .circleClicked(let index):
        state.page.update(.move(increment: index))
      case .nextTapped, .nextButtonTapped:
        state.page.update(.next)
        state.pageIdx = 1
      case .textFieldStateChanged(let textFieldState):
        state.textFieldState = textFieldState
      case .previousTapped:
        if state.page.index == 0 {
          return .none
        } else {
          state.page.update(.previous)
        }
      case .nicknameEdited(let nickname):
        state.nickname = String(nickname.prefix(20))
        if nickname.isNicknameValid {
          state.textFieldState = nickname.count >= 2 ? .nicknameCorrect : .editing
        } else {
          state.textFieldState = .error
        }
      case .emailEdited(let email):
        state.email = email
        if email.isEmailValid {
          state.textFieldState = email.count >= 2 ? .emailCorrect : .editing
        } else {
          state.textFieldState = .emailError
        }
      case .invitationcodeEdited(let code):
        state.invitationInputCode = code
      case .invitationViewLoaded(let code):
            state.invitationCode = code
      case .genderSelected(let gender):
        state.gender = gender
        state.buttonClickState = .clicked
      case .birthdateYearSelected(let year):
        state.birthdateYear = year
      case .birthdateMonthSelected(let month):
        state.birthdateMonth = month
      case .birthdateDaySelected(let day):
        state.birthdateDay = day
      case .dateYearSelected(let year):
        state.firstdateYear = year
      case .dateMonthSelected(let month):
        state.firstdateMonth = month
      case .dateDaySelected(let day):
        state.firstdateDay = day
      case .showBottomSheet:
        state.showBottomSheet = true
      case .hideBottomSheet:
        state.showBottomSheet = false
      case .birthdateInitialied:
        state.birthdateYear = Date().year
        state.birthdateMonth = Date().month
        state.birthdateDay = Date().day
      case .dateInitialied:
        state.firstdateYear = Date().year
        state.firstdateMonth = Date().month
        state.firstdateDay = Date().day
      case .imageSelected(let image):
        state.profileImage = image
      case .doneButtonTapped:
        return .run { [state = state] send in
          do {
            let birthyear = state.birthdateYear
            let birthmonth = state.birthdateMonth
            let birthday = state.birthdateDay
            let firstyear = state.firstdateYear
            let firstmonth = state.firstdateMonth
            let firstday = state.firstdateDay
            let birth = String(format: "%04d-%02d-%02d", birthyear, birthmonth, birthday)
            let firstDate = String(format: "%04d-%02d-%02d", firstyear, firstmonth, firstday)
            // 프로필 등록 - 생년월일 입력 뷰에서 다음 버튼 클릭시
            let profile = try await self.apiClient.request(.registerProfile(authorization: state.accessToken, refresh: state.refreshToken, image: state.profileImage, profileRequest: RegisterProfileRequest.init(email: state.email, nickname: state.nickname, birthDay: birth, firstDate: firstDate, gender: state.gender, deviceToken: "fcm"))) as Profile
            
            await send(.registerProfileResponse(.success(profile)))
          } catch {
            print("프로필 등록 실패")
          }
        }
//        return .task { [accessToken = state.accessToken, refreshToken = state.refreshToken, image = state.profileImage, email = state.email, nickname = state.nickname, birthYear = state.birthdateYear, birthMonth = state.birthdateMonth, birthDay = state.birthdateDay, year = state.firstdateYear, month = state.firstdateMonth, day = state.firstdateDay, gender = state.gender] in
//            .signUpResponse(
//              await TaskResult {
//                try await self.apiClient.requestMultipartform(accessToken: accessToken, refreshToken: refreshToken, image: image, signUpRequest: .init(email: email, nickname: nickname, birthDay: "\(birthYear)-\(birthMonth)-\(birthDay)", firstDate: "\(year)-\(month)-\(day)", gender: gender, deviceToken: "fj3vn9m"))
//              }
//            )
//
//
//        }
      default:
        break
      }
      return .none
    }
  }
}

extension Page: Equatable {
  public static func == (lhs: Page, rhs: Page) -> Bool {
    lhs.index == rhs.index
  }
}

// AppDelegate().appDeviceToken
