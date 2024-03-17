//
//  PresignedURL.swift
//  LoveBird
//
//  Created by 황득연 on 3/4/24.
//

import Foundation

enum PresignedURL {
  case profile
  case diary

  var fileName: String {
    switch self {
    case .profile:
      return "profile.png"

    case .diary:
      return "diary.png"
    }
  }
}
