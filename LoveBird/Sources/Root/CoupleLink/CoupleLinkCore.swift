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
    var textFieldState: OnboardingTextFieldState = .none
  }
  
  enum Action: Equatable {
    case textFieldStateChanged(OnboardingTextFieldState)
    case tryLinkResponse(TaskResult<TryLinkResponse>)
    case imageSelected(UIImage?)
    case circleClicked(Int)
    case invitationViewLoaded(String)
    case invitationcodeEdited(String)
    case isSuccessTryLink(Bool)
    case none
  }
  
  @Dependency(\.apiClient) var apiClient
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .textFieldStateChanged(let state):
//        state.textFieldState = state
        print("??")
      case .invitationcodeEdited(let code):
        state.invitationInputCode = code
      case .invitationViewLoaded(let code):
            state.invitationCode = code
      case .isSuccessTryLink(let bool):
        return .run { send in
          do {
            let tryLinkResponse = TryLinkResponse(isSuccess: bool)
            
            await send(.tryLinkResponse(.success(tryLinkResponse)))
          } catch {
            print("link error!")
          }
        }
      default:
        break
      }
      return .none
    }
  }
}
