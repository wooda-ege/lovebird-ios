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

struct OnboardingCore: ReducerProtocol {
  struct State: Equatable {
    
    init(accessToken: String, refreshToken: String) {
      self.accessToken = accessToken
      self.refreshToken = refreshToken
    }
    
    var accessToken: String = ""
    var refreshToken: String = ""
    
    var page: Page = .first()
    var nickname: String = ""
    var textFieldState: TextFieldState = .none
    var buttonClickState: ButtonClickState = .notClicked
    var showBottomSheet = false
    var gender = ""
    var birthdateYear: Int = Calendar.year
    var birthdateMonth: Int = Calendar.month
    var birthdateDay: Int = Calendar.day
    var firstdateYear: Int = Calendar.year
    var firstdateMonth: Int = Calendar.month
    var firstdateDay: Int = Calendar.day
    var email: String = ""
    var invitationCode: String = "12akvow14"
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
    case invitationcodeEdited(String)
    case doneButtonTapped
    case showBottomSheet
    case hideBottomSheet
    case dateInitialied
    case birthdateInitialied
    case signUpResponse(TaskResult<SignUpResponse>)
    case imageSelected(UIImage?)
    case circleClicked(Int)
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
      case .textFieldStateChanged(let textFieldState):
        state.textFieldState = textFieldState
      case .previousTapped:
        if state.page.index == 0 {
          return .none
        } else {
          state.page.update(.previous)
        }
      case .nicknameEdited(let nickname):
        state.nickname = nickname
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
        state.birthdateYear = Calendar.year
        state.birthdateMonth = Calendar.month
        state.birthdateDay = Calendar.day
      case .dateInitialied:
        state.firstdateYear = Calendar.year
        state.firstdateMonth = Calendar.month
        state.firstdateDay = Calendar.day
      case .imageSelected(let image):
        state.profileImage = image
      case .doneButtonTapped:
        return .task { [accessToken = state.accessToken, refreshToken = state.refreshToken, image = state.profileImage, email = state.email, nickname = state.nickname, birthYear = state.birthdateYear, birthMonth = state.birthdateMonth, birthDay = state.birthdateDay, year = state.firstdateYear, month = state.firstdateMonth, day = state.firstdateDay, gender = state.gender] in
            .signUpResponse(
              await TaskResult {
                try await self.apiClient.requestMultipartform(accessToken: accessToken, refreshToken: refreshToken, image: image, signUpRequest: .init(email: email, nickname: nickname, birthDay: "\(birthYear)-\(birthMonth)-\(birthDay)", firstDate: "\(year)-\(month)-\(day)", gender: gender, deviceToken: "fj3vn9m"))
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

extension Page: Equatable {
  public static func == (lhs: SwiftUIPager.Page, rhs: SwiftUIPager.Page) -> Bool {
    lhs.index == rhs.index
  }
}

// AppDelegate().appDeviceToken
