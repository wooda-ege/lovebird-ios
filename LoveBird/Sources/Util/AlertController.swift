//
//  AlertController.swift
//  LoveBird
//
//  Created by 황득연 on 12/25/23.
//

import Combine
import SwiftUI

final class AlertController {
  struct Style: Equatable {
    let title: String
    let description: String
    let positiveButton: String
    let negativeButton: String
  }

  @Published var style: Style?
  @Published var buttonClick = PassthroughSubject<Bool, Never>()

  func showAlert(style: Style) {
    self.style = style
  }
}

extension AlertController.Style {
  static let deleteDiary: AlertController.Style =
    AlertController.Style(
      title: "일기를 삭제하시겠어요?",
      description: "일기를 삭제하면 다시 되돌릴 수 없어요",
      positiveButton: "삭제",
      negativeButton: "취소"
    )

  static let deleteSchedule: AlertController.Style =
  AlertController.Style(
    title: "일정을 삭제하시겠어요?",
    description: "일정을 삭제하면 다시 되돌릴 수 없어요",
    positiveButton: "삭제",
    negativeButton: "취소"
  )
}
