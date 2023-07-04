//
//  ScheduleColor.swift
//  LoveBird
//
//  Created by 황득연 on 2023/06/30.
//

import SwiftUI

enum ScheduleColor: CaseIterable {
  case secondary
  case primary
  case gray
  case none

  var description: String {
    switch self {
    case .secondary:
      return String(resource: R.string.localizable.color_secondary)
    case .primary:
      return String(resource: R.string.localizable.color_primary)
    case .gray:
      return String(resource: R.string.localizable.color_gray)
    case .none:
      return String(resource: R.string.localizable.add_schedule_color)
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
