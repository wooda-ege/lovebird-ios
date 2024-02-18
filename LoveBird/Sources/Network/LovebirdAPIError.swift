//
//  LovebirdAPIError.swift
//  LoveBird
//
//  Created by 황득연 on 2023/06/18.
//

import Foundation

enum LovebirdAPIError: String, Error {
  case emptyData

  // 1000~9999 는 서버와 약속된 오류이다.
  case bearerPrefixMissing = "1100"
  case invalidJWTToken = "1101"

  case invalidAuthProvider = "1200"
  case duplicateRegistration = "1201"
  case memberNotFound = "1202"

  case profileNotFound = "1250"

  case userAlreadyCoupled = "1300"
  case cannotCoupleWithSelf = "1301"

  case invalidUserInfo = "1400"

  case wrongParameter = "8000"

  case internalServerError = "9998"
  case externalServerError = "9999"
}
