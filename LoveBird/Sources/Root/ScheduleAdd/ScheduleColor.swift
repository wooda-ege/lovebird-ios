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
      return String(resource: R.string.localizable.diary_note)
    case .primary:
      return String(resource: R.string.localizable.common_confirm)
    case .gray:
      return String(resource: R.string.localizable.common_next)
    case .none:
      return String(resource: R.string.localizable.common_next)
    }
  }

  var color: Color {
    switch self {
    case .secondary:
      return Color(R.color.secondary)
    case .primary:
      return Color(R.color.primary)
    case .gray:
      return Color(R.color.gray04)
    case .none:
      return .white
    }
  }
}
