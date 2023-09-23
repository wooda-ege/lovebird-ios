//
//  AuthRequest.swift
//  LoveBird
//
//  Created by 이예은 on 2023/09/23.
//

import Foundation

struct AuthRequest: Encodable {
  let provider: String
  let idToken: String
  let name: String
  let email: String?
}
