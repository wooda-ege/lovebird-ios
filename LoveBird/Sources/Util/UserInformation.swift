//
//  UserInformation.swift
//  LoveBird
//
//  Created by 이예은 on 2023/09/23.
//

import Foundation

struct UserInformation: Codable {
  let email: String
  let name: PersonNameComponents
  let identifier: String

  func displayName(style: PersonNameComponentsFormatter.Style = .default) -> String {
    PersonNameComponentsFormatter.localizedString(from: name, style: style)
  }
}
