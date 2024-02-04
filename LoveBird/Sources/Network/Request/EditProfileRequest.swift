//
//  EditProfileRequest.swift
//  LoveBird
//
//  Created by 황득연 on 2023/08/13.
//

import Foundation

public struct EditProfileRequest: Encodable {

  init(
    imageUrl: String? = nil,
    nickname: String? = nil,
    email: String? = nil,
    firstDate: String? = nil,
    birthday: String? = nil
  ) {
    self.imageUrl = imageUrl
    self.nickname = nickname
    self.email = email
    self.firstDate = firstDate
    self.birthday = birthday
  }

  let imageUrl: String?
  let nickname: String?
  let email: String?
  let firstDate: String?
  let birthday: String?
}
