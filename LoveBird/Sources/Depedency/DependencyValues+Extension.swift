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

  var alertController: AlertController {
    get { self[AlertController.self] }
    set { self[AlertController.self] = newValue }
  }

  var toastController: ToastController {
    get { self[ToastController.self] }
    set { self[ToastController.self] = newValue }
  }

  var kakaoLoginUtil: KakaoLoginUtil {
    get { self[KakaoLoginUtil.self] }
    set { self[KakaoLoginUtil.self] = newValue }
  }

  var appleLoginUtil: AppleLoginUtil {
    get { self[AppleLoginUtil.self] }
    set { self[AppleLoginUtil.self] = newValue }
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

extension AlertController: DependencyKey {
  static public let liveValue = AlertController()
}

extension ToastController: DependencyKey {
  static public let liveValue = ToastController()
}

extension KakaoLoginUtil: DependencyKey {
  static public let liveValue = KakaoLoginUtil()
}

extension AppleLoginUtil: DependencyKey {
  static public let liveValue = AppleLoginUtil()
}
