//
//  UserDataKeychain.swift
//  LoveBird
//
//  Created by 이예은 on 2023/09/23.
//

import Foundation

struct UserDataKeychain: Keychain {
  typealias DataType = UserInformation
  
  // Make sure the account name doesn't match the bundle identifier!
  var account = "com.lovebird.ios"
  var service = "userIdentifier"
}
