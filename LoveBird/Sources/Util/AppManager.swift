//
//  AppManager.swift
//  LoveBird
//
//  Created by 황득연 on 12/11/23.
//

import ComposableArchitecture

public class AppConfiguration {

  // MARK: - Enumeration

  enum Mode {
    case single
    case couple
  }

  // MARK: - Dependencies

  @Dependency(\.userData) var userData

  // MARK: - Properties

  var mode: Mode {
    let profile = userData.get(key: .user, type: Profile.self)
    return profile?.isLinked == true ? .couple : .single
  }
}

extension DependencyValues {
  var appConfiguration: AppConfiguration {
    get { self[AppConfiguration.self] }
    set { self[AppConfiguration.self] = newValue }
  }
}

extension AppConfiguration: DependencyKey {
  static public let liveValue = AppConfiguration()
}
