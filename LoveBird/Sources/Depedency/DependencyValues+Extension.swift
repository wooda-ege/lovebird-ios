//
//  DependencyValues+Extension.swift
//  LoveBird
//
//  Created by 황득연 on 12/8/23.
//

import ComposableArchitecture
import Moya

extension DependencyValues {
  var userData: UserData {
    get { self[UserData.self] }
    set { self[UserData.self] = newValue }
  }
  
  var lovebirdApi: LovebirdAPI {
    get { self[LovebirdAPI.self] }
    set { self[LovebirdAPI.self] = newValue }
  }

  var appConfiguration: AppConfiguration {
    get { self[AppConfiguration.self] }
    set { self[AppConfiguration.self] = newValue }
  }

  var loadingController: LoadingController {
    get { self[LoadingController.self] }
    set { self[LoadingController.self] = newValue }
  }
}

// MARK: - `DependencyKey` Implementation

extension UserData: DependencyKey {
  static public let liveValue = Self()
}

extension LovebirdAPI: DependencyKey {
  public static var liveValue = LovebirdAPI(apiClient: MoyaProvider<APIClient>())
}

extension AppConfiguration: DependencyKey {
  static public let liveValue = AppConfiguration()
}

extension LoadingController: DependencyKey {
  static public let liveValue = LoadingController()
}
