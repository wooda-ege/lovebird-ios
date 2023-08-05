//
//  KakaoLoginResponse.swift
//  LoveBird
//
//  Created by 이예은 on 2023/07/09.
//

import Foundation

//struct KakaoLoginResponse: Decodable, Equatable, Sendable {
//  let status: String
//  let message: String
//  let data: JWTTokenResponse
//}

struct KakaoLoginResponse: Decodable, Equatable, Sendable {
  let accessToken: String
  let refreshToken: String?
}
