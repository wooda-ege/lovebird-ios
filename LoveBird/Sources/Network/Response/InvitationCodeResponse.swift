//
//  InvitationCodeResponse.swift
//  LoveBird
//
//  Created by 이예은 on 2023/08/14.
//

struct InvitationCodeResponse: Decodable, Equatable, Sendable {
  let memberId: Int
  let coupleCode: String
}
