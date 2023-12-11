//
//  SignUpResponse.swift
//  LoveBird
//
//  Created by 이예은 on 2023/09/25.
//

struct Token: Codable, Equatable {
  let accessToken: String
  let refreshToken: String
  let linkedFlag: Bool?
}
