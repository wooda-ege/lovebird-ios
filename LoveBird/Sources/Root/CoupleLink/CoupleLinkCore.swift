//
//  CoupleLinkCore.swift
//  wooda
//
//  Created by 이예은 on 2023/08/16.
//

import ComposableArchitecture
import SwiftUIPager
import Foundation
import SwiftUI
import UIKit

typealias CoupleLinkState = CoupleLinkCore.State
typealias CoupleLinkAction = CoupleLinkCore.Action

struct CoupleLinkCore: Reducer {
  struct State: Equatable {
    var invitationCode: String = ""
    var invitationInputCode: String = ""
    var textFieldState: TextFieldState = .none
    var isShareSheetShown = false
  }
  
  enum Action: Equatable {
    case viewAppear
    case successToLink
    case initialInvitationCode(String)
    case imageSelected(UIImage?)
    case invitationCodeEdited(String)
    case shareTapped(Bool)
    case confirmButtonTapped
  }
  
  @Dependency(\.lovebirdApi) var lovebirdApi

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .viewAppear:
        return .run { send in
          let coupleCode = try await lovebirdApi.fetchCoupleCode()
          await send(.initialInvitationCode(coupleCode.coupleCode))
        }

      case let .initialInvitationCode(code):
        state.invitationCode = code
        return .none

      case .confirmButtonTapped:
        return .run { [code = state.invitationInputCode] send in
          let status = if code.isEmpty {
            try await lovebirdApi.checkIsLinked()
          } else {
            try await lovebirdApi.linkCouple(linkCouple: .init(coupleCode: code))
          }
          if status == "SUCCESS" {
            await send(.successToLink)
          } else {
            print("Failure to Link")
          }
        }

      case .invitationCodeEdited(let code):
        state.invitationInputCode = code
        return .none

      case let .shareTapped(isShown):
        state.isShareSheetShown = isShown
        return .none

      default:
        return .none
      }
    }
  }
}
