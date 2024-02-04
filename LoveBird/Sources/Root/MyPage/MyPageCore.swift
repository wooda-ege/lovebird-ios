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
    var user: Profile?
    var showBottomSheet: Bool = false
    var mypageLink = MyPageLinkState()
  }
  
  // MARK: - Action
  
  enum Action: Equatable {
    case partnerProfileTapped
    case privacyPolicyTapped
    case viewAppear
    case editTapped
    case alertButtonTapped(AlertController.Style.`Type`?)
    
    case showBottomSheet
    case hideBottomSheet
    case mypageLink(MyPageLinkAction)
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
        
        let user = self.userData.get(key: .user, type: Profile.self)
        if let user { state.user = user }
        return .send(.hideBottomSheet)
        
      case .partnerProfileTapped:
        alertController.showAlert(type: .link)
        
        return .publisher {
          alertController.buttonClick
            .map(Action.alertButtonTapped)
        }
        
      case let .alertButtonTapped(type):
        switch type {
        case .link:
          return .send(.showBottomSheet)
          
        default:
          return .none
        }
        
      case .showBottomSheet:
        state.showBottomSheet = true
        return .none
        
      case .hideBottomSheet:
        state.showBottomSheet = false
        return .none
        
      case .mypageLink(.successToLink):
        return .send(.successToLink)
        
      default:
        return .none
      }
    }
  }
}

typealias MyPageState = MyPageCore.State
typealias MyPageAction = MyPageCore.Action
