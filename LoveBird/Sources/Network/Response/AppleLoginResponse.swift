//
//  AppleLoginResponse.swift
//  LoveBird
//
//  Created by 이예은 on 2023/07/17.
//

import Foundation

struct AppleLoginResponse: Decodable, Equatable, Sendable {
  let accessToken: String
  let refreshToken: String?
  let flag: Bool
}
