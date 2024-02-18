//
//  LoveBirdApp.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/13.
//

import SwiftUI
import ComposableArchitecture
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

@main
struct LoveBirdApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  init() {
    KakaoSDK.initSDK(appKey: Config.kakaoAppKey)
  }

  var body: some Scene {
    WindowGroup {
      RootView(
        store: Store(
          initialState: RootCore.State(),
          reducer: { RootCore()._printChanges(.lovebirdDump) }
        )
      )
      .accentColor(.black)
      .preferredColorScheme(.light)
      .onOpenURL(perform: { url in
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
          let _ = AuthController.handleOpenUrl(url: url)
        }
      })
    }
  }
}
