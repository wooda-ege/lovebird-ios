//
//  SignUpResponse.swift
//  LoveBird
//
//  Created by 이예은 on 2023/10/25.
//

import Foundation

struct SignUpResponse: Codable, Equatable, Sendable {
  let accessToken: String
  let refreshToken: String
}
