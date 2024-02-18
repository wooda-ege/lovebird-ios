//
//  AppDelegate.swift
//  LoveBird
//
//  Created by 황득연 on 2/18/24.
//

import UIKit
import SwiftUI
import ComposableArchitecture

final class AppDelegate: UIResponder, UIApplicationDelegate {
  @Dependency(\.userData) var userData

  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    print("hihihihihi")
    // 디바이스 토큰 처리
    let tokenParts = deviceToken.map { data -> String in
      return String(format: "%02.2hhx", data)
    }
    let token = tokenParts.joined()
    userData.deviceToken.value = token
    print("Device Token: \(token)")
  }

  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
      // 디바이스 토큰 등록 실패 처리
      print("Failed to register for remote notifications: \(error.localizedDescription)")
  }
}
