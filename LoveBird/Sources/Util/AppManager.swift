//
//  AppManager.swift
//  LoveBird
//
//  Created by 황득연 on 12/11/23.
//

import ComposableArchitecture

public class AppConfiguration {

  // MARK: - Enumeration

  enum Mode: Codable {
    case single
    case couple
    case none
  }
}
