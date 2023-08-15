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
