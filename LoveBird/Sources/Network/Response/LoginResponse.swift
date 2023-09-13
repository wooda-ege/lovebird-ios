//
//  LoginResponse.swift
//  LoveBird
//
//  Created by 이예은 on 2023/07/09.
//

import Foundation

struct LoginResponse: Decodable, Equatable, Sendable {
  let idToken: String
  let name: String
  let email: String?
}
