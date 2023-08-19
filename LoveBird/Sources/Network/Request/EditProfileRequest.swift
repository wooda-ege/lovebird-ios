//
//  EditProfileRequest.swift
//  LoveBird
//
//  Created by 황득연 on 2023/08/13.
//

import Foundation

public struct EditProfileRequest: Encodable {
  let nickname: String
  let email: String
}
