//
//  ToastController.swift
//  LoveBird
//
//  Created by 황득연 on 12/26/23.
//

import Combine
import SwiftUI
import ComposableArchitecture

public final class ToastController {

  @Dependency(\.continuousClock) var clock
  @Published var message: String?

  func showToast(message: String) async {
    Task {
      self.message = message
      try await clock.sleep(for: .seconds(2))
      self.message = nil
    }
  }
}

