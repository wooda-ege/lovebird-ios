//
//  UserData.swift
//  LoveBird
//
//  Created by 황득연 on 2023/06/06.
//

import Foundation
import ComposableArchitecture

public struct UserData {
  enum Keys: String, CaseIterable {
    case user
    case accessToken
    case refreshToken
  }
  
  func store<T: Encodable>(key: Keys, value: T) {
    let encodedData = try? JSONEncoder().encode(value)
    UserDefaults.standard.set(encodedData, forKey: key.rawValue)
  }
  
  func get<T: Decodable>(key: Keys, type: T.Type) -> T? {
    if let savedData = UserDefaults.standard.data(forKey: key.rawValue) {
        do {
            let decodedProfile = try JSONDecoder().decode(type.self, from: savedData)
            return decodedProfile
        } catch {
            return nil
        }
    }
    return nil
  }

  func remove(key: Keys) {
    UserDefaults.standard.removeObject(forKey: key.rawValue)
  }

  func removeAll() {
    Keys.allCases.forEach {
      self.remove(key: $0)
    }
  }
}

extension DependencyValues {
  var userData: UserData {
    get { self[UserData.self] }
    set { self[UserData.self] = newValue }
  }
}

extension UserData: DependencyKey {
  static public let liveValue = Self()
}
