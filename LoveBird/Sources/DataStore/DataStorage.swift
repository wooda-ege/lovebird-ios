//
//  DataStorage.swift
//  LoveBird
//
//  Created by 황득연 on 2/17/24.
//

import Combine
import SwiftUI

protocol Removable {
  func remove()
}

final class DataStorage<T: Codable> {
  private let userDefaultsManager: UserDefaultsManager = UserDefaultsManagerImpl.shared
  private let key: UserDataKey
  private let defaultValue: T
  @Published var subject = PassthroughSubject<T, Never>()

  init(key: UserDataKey, defaultValue: T) {
    self.key = key
    self.defaultValue = defaultValue
    self.subject.send(value)
  }

  var value: T {
    get { 
      if let data = userDefaultsManager.get(key: key, type: T.self) {
        return data
      } else {
        return defaultValue
      }
    }
    set {
      userDefaultsManager.store(key: key, value: newValue)
      subject.send(value)
    }
  }
}

extension DataStorage: Removable {
  func remove() {
    value = defaultValue
    userDefaultsManager.remove(key: key)
  }
}
