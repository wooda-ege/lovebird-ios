//
//  UserDefaultsManager.swift
//  LoveBird
//
//  Created by 황득연 on 2/17/24.
//

import Foundation
import ComposableArchitecture

protocol UserDefaultsManager {
  func store<T: Encodable>(key: UserDataKey, value: T)
  func get<T: Decodable>(key: UserDataKey, type: T.Type) -> T?
  func remove(key: UserDataKey)
  func removeAll()
}

public struct UserDefaultsManagerImpl: UserDefaultsManager {
  static let shared: UserDefaultsManager = UserDefaultsManagerImpl()
  private init() {}

  func store<T: Encodable>(key: UserDataKey, value: T) {
    let encodedData = try? JSONEncoder().encode(value)
    UserDefaults.standard.set(encodedData, forKey: key.rawValue)
  }

  func get<T: Decodable>(key: UserDataKey, type: T.Type) -> T? {
    guard let savedData = UserDefaults.standard.data(forKey: key.rawValue) else { return nil }
    do {
        let data = try JSONDecoder().decode(type.self, from: savedData)
        return data
    } catch {
        return nil
    }
  }

  func remove(key: UserDataKey) {
    UserDefaults.standard.removeObject(forKey: key.rawValue)
  }

  func removeAll() {
    UserDataKey.allCases.forEach {
      self.remove(key: $0)
    }
  }
}
