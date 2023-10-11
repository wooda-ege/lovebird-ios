//
//  AuthRequest.swift
//  LoveBird
//
//  Created by 이예은 on 2023/09/23.
//

import Foundation

public struct AuthRequest: Encodable, Equatable, Sendable {
  let provider: SNSProvider
  let idToken: String
}

enum SNSProvider: String, Encodable, Equatable, Sendable {
  case apple = "APPLE"
  case kakao = "KAKAO"
}
