//
//  Authenticate.swift
//  LoveBird
//
//  Created by 이예은 on 2023/10/25.
//

import Foundation

public struct Authenticate: Encodable, Equatable {
  let provider: SNSProvider
  let idToken: String

  static let dummy: Self = .init(provider: .kakao, idToken: "1234")
}

public enum SNSProvider: String, Encodable, Equatable {
  case apple = "APPLE"
  case kakao = "KAKAO"
}
