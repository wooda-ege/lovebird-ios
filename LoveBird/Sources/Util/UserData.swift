//
//  UserData.swift
//  LoveBird
//
//  Created by 황득연 on 2023/06/06.
//

import Foundation
import ComposableArchitecture

struct UserData {
  enum Keys: String {
    case user
  }
  
  func store(key: Keys, value: Any) {
    UserDefaults.standard.set(value, forKey: key.rawValue)
  }
  
  func get(key: Keys) -> Any? {
    return UserDefaults.standard.object(forKey: key.rawValue)
  }
}

extension DependencyValues {
  var userData: UserData {
    get { self[UserData.self] }
    set { self[UserData.self] = newValue }
  }
}

extension UserData: DependencyKey {
  static let liveValue = Self()
}
