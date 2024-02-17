//
//  UserData.swift
//  LoveBird
//
//  Created by 황득연 on 2023/06/06.
//

import Foundation
import ComposableArchitecture

enum UserDataKey: String, CaseIterable {
  case profile
  case accessToken
  case refreshToken
  case mode
  case shouldShowLinkSuccessPopup
  case deviceToken
}

public struct UserData {
  let profile = DataStorage<Profile?>(key: .profile, defaultValue: nil)
  let accessToken = DataStorage<String>(key: .accessToken, defaultValue: "")
  let refreshToken = DataStorage<String>(key: .refreshToken, defaultValue: "")
  let mode = DataStorage<AppConfiguration.Mode>(key: .mode, defaultValue: .none)
  let shouldShowLinkSuccessPopup = DataStorage<Bool>(key: .shouldShowLinkSuccessPopup, defaultValue: true)
  let deviceToken = DataStorage<String>(key: .deviceToken, defaultValue: "")
}

extension UserData {
  func reset() {
    removeAll(self)
  }
  
  private func removeAll(_ target: Any) {
      for c in Mirror(reflecting: target).children {
          if let instance = c.value as? Removable {
              instance.remove()
          }
      }
  }
}
