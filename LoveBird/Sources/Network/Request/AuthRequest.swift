//
//  AuthRequest.swift
//  LoveBird
//
//  Created by 이예은 on 2023/09/23.
//

import Foundation

public struct AuthRequest: Encodable {
  let provider: Provider
  let idToken: String
}

enum Provider: String, Encodable {
  case APPLE
  case KAKAO
}
