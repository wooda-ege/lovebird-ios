//
//  MyPageCore.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/28.
//

import ComposableArchitecture

struct MyPageCore: Reducer {
  
  // MARK: - State
  
  struct State: Equatable {
    var profile: Profile?
    var mypageLink = MyPageLinkState()
    var isCoupleLinkVisible: Bool = false
  }
  
  // MARK: - Action
  
  enum Action: Equatable {
    case partnerProfileTapped
    case privacyPolicyTapped
    case viewAppear
    case editTapped
    case alertButtonTapped(AlertController.Style.`Type`?)
    case mypageLink(MyPageLinkAction)
    case profileUpdated(Profile?)

    // Couple Link
    case confirmButtonTapped
    case linkViewVisible(Bool)
    case successToLink
  }
  
  // MARK: - Dependency
  
  @Dependency(\.userData) var userData
  @Dependency(\.alertController) var alertController
  // MARK: - Body
  
  var body: some Reducer<State, Action> {
    Scope(state: \.mypageLink, action: /Action.mypageLink) {
      MyPageLinkCore()
    }
    Reduce { state, action in
      switch action {
      case .viewAppear:
        state.profile = userData.profile.value
        return .publisher {
          userData.profile.subject
            .map(Action.profileUpdated)
        }
        
      case .partnerProfileTapped:
        alertController.showAlert(type: .link)
        
        return .publisher {
          alertController.buttonClick
            .map(Action.alertButtonTapped)
        }
        
      case let .alertButtonTapped(type):
        switch type {
        case .link:
          return .send(.linkViewVisible(true))

        default:
          return .none
        }
        
      case .linkViewVisible(let visible):
        state.isCoupleLinkVisible = visible
        return .none

      case .profileUpdated(let profile):
        state.profile = profile
        return .none

      default:
        return .none
      }
    }
  }
}

typealias MyPageState = MyPageCore.State
typealias MyPageAction = MyPageCore.Action
