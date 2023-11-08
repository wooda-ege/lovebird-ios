//
//  WebApi.swift
//  LoveBird
//
//  Created by 이예은 on 2023/09/23.
//

import Foundation

struct WebApi {
  static func Register(user: UserInformation, identityToken: Data?, authorizationCode: Data?) throws -> Bool {
    return true
  }
  
  static func Login(user: String, identityToken: Data?, authorizationCode: Data?) throws -> Bool {
    return true
  }
}
