//
//  InvitationCodeResponse.swift
//  LoveBird
//
//  Created by 이예은 on 2023/08/14.
//

struct CoupleCode: Decodable, Equatable, Sendable {
  let memberId: Int
  let coupleCode: String
}
