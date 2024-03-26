//
//  MyPageLinkCore.swift
//  LoveBird
//
//  Created by 이예은 on 1/7/24.
//

import SwiftUI
import ComposableArchitecture

typealias MyPageLinkState = MyPageLinkCore.State
typealias MyPageLinkAction = MyPageLinkCore.Action

struct MyPageLinkCore: Reducer {
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
    case invitationCodeEdited(String)
    case shareVisible(Bool)
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
          if code.isEmpty {
            let response = try await lovebirdApi.checkLinkedOrNot()
            if response.linkedFlag {
              await send(.successToLink)
            }
          } else {
            _ = try await lovebirdApi.linkCouple(linkCouple: .init(coupleCode: code))
            await send(.successToLink)
          }
        }

      case .invitationCodeEdited(let code):
        state.invitationInputCode = code
        return .none

      case let .shareVisible(visible):
        state.isShareSheetShown = visible
        return .none

      default:
        return .none
      }
    }
  }
}
