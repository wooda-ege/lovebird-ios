//
//  SignUpResponse.swift
//  LoveBird
//
//  Created by 이예은 on 2023/09/25.
//

struct SignUpResponse: Codable, Equatable, Sendable {
  let accessToken: String
  let refreshToken: String
}
