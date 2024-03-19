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

  var tokenManager: TokenManager {
    get { self[TokenManager.self] }
    set { self[TokenManager.self] = newValue }
  }
}

// MARK: - `DependencyKey` Implementation

extension UserData: DependencyKey {
  public static let liveValue = UserData()
}

extension LovebirdAPI: DependencyKey {
  public static let liveValue = LovebirdAPI(apiClient: MoyaProvider<APIClient>(session: Session(interceptor: AuthInterceptor.shared)))
}

extension AppConfiguration: DependencyKey {
  public static let liveValue = AppConfiguration()
}

extension LoadingController: DependencyKey {
  public static let liveValue = LoadingController()
}

extension AlertController: DependencyKey {
  public static let liveValue = AlertController()
}

extension ToastController: DependencyKey {
  public static let liveValue = ToastController()
}

extension KakaoLoginUtil: DependencyKey {
  public static let liveValue = KakaoLoginUtil()
}

extension AppleLoginUtil: DependencyKey {
  public static let liveValue = AppleLoginUtil()
}

extension TokenManager: DependencyKey {
  public static let liveValue = TokenManager()
}
