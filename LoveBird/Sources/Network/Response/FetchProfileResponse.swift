//
//  FetchProfileResponse.swift
//  LoveBird
//
//  Created by 황득연 on 2023/08/02.
//

import Foundation

struct FetchProfileResponse: Decodable, Equatable, Sendable {
  let nickname: String
  let partnerNickname: String
  let firstDate: String
  let dayCount: Int
  let nextAnniversary: Anniversary
  let profileImageUrl: String?
  let partnerImageUrl: String?

  struct Anniversary: Decodable, Equatable {
    let kind: String
    let anniversaryDate: String
  }
}
