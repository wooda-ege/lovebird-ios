//
//  KakaoLoginRequest.swift
//  LoveBird
//
//  Created by 이예은 on 2023/07/09.
//

import Foundation

public struct KakaoLoginRequest: Encodable {
  let idToken: String
  let accessToken: String
}

