//
//  SignUpResponse.swift
//  LoveBird
//
//  Created by 황득연 on 2023/06/04.
//

struct FetchProfileResponse: Codable, Equatable, Sendable {
  let memberId: Int
  let partnerId: Int?
  let email: String
  let nickname: String
  let partnerNickname: String?
  let firstDate: String?
  let birthDay: String?
  let dayCount: Int?
  let nextAnniversary: Profile.Anniversary?
  let profileImageUrl: String?
  let partnerImageUrl: String?
}

extension FetchProfileResponse {
  func toProfile() -> Profile {
    Profile(
      memberId: memberId,
      partnerId: partnerId,
      email: email,
      nickname: nickname,
      partnerNickname: partnerNickname,
      firstDate: firstDate,
      birthDay: birthDay,
      dayCount: dayCount,
      nextAnniversary: nextAnniversary,
      profileImageUrl: profileImageUrl,
      partnerImageUrl: partnerImageUrl
    )
  }
}
