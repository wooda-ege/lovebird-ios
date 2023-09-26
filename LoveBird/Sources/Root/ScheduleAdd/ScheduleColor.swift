//
//  ScheduleColor.swift
//  LoveBird
//
//  Created by 황득연 on 2023/06/30.
//

import SwiftUI

enum ScheduleColor: String, Codable, CaseIterable {
  case secondary = "SECONDARY"
  case primary = "PRIMARY"
  case gray = "GRAY"
  case none

  var description: String {
    switch self {
    case .secondary:
      return LoveBirdStrings.colorSecondary
    case .primary:
      return LoveBirdStrings.colorPrimary
    case .gray:
      return LoveBirdStrings.colorGray
    case .none:
      return LoveBirdStrings.addScheduleColor
    }
  }

  var color: Color {
    switch self {
    case .secondary:
      return Color(asset: LoveBirdAsset.secondary)
    case .primary:
      return Color(asset: LoveBirdAsset.primary)
    case .gray:
      return Color(asset: LoveBirdAsset.gray04)
    case .none:
      return .white
    }
  }
}
