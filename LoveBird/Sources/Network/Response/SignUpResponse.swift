//
//  SignUpResponse.swift
//  LoveBird
//
//  Created by 황득연 on 2023/06/04.
//

struct SignUpResponse: Codable, Equatable, Sendable {
    let status, message: String
    let data: SignUpData
}

struct SignUpData: Codable, Equatable, Sendable {
  let nickname: String
  let partnerNickname: String?
  let firstDate: String
  let dayCount: Int
  let nextAnniversary: NextAnniversary
  let profileImageUrl: String?
  let partnerImageUrl: String?
}

struct NextAnniversary: Codable, Equatable, Sendable {
  let kind: String
  let anniversaryDate: String
}
