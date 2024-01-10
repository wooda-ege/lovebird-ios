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

    init(title: String, description: String, positiveButton: String, negativeButton: String) {
      self.title = title
      self.description = description
      self.positiveButton = positiveButton
      self.negativeButton = negativeButton
    }

    init(title: String, positiveButton: String, negativeButton: String) {
      self.init(
        title: title,
        description: "",
        positiveButton: positiveButton,
        negativeButton: negativeButton
      )
    }
  }

  @Published var type: AlertController.Style.`Type`?
  @Published var buttonClick = PassthroughSubject<AlertController.Style.`Type`?, Never>()

  func showAlert(type: AlertController.Style.`Type`?) {
    self.type = type
  }
}

extension AlertController.Style {
  enum `Type` {
    case deleteDiary
    case deleteSchedule
    case logout
    case withdrawal
    case link

    var content: AlertController.Style {
      switch self {
      case .deleteDiary:
        AlertController.Style.deleteDiary

      case .deleteSchedule:
        AlertController.Style.deleteSchedule

      case .logout:
        AlertController.Style.logout

      case .withdrawal:
        AlertController.Style.withdrawal
        
      case .link:
        AlertController.Style.link
      }
    }
  }

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

  static let logout: AlertController.Style =
    AlertController.Style(
      title: "로그아웃을 하시겠어요?",
      positiveButton: "확인",
      negativeButton: "취소"
    )

  static let withdrawal: AlertController.Style =
    AlertController.Style(
      title: "회원탈퇴를 하시겠어요?",
      description: "탈퇴를 하게 되면 모든 정보를 복구할 수 없어요",
      positiveButton: "확인",
      negativeButton: "취소"
    )
  
  static let link: AlertController.Style =
    AlertController.Style(
      title: "연인과 연결하시겠어요?",
      description: "초대코드를 발송하거나 입력할 수 있어요",
      positiveButton: "연결하러 가기",
      negativeButton: "취소"
    )
}
