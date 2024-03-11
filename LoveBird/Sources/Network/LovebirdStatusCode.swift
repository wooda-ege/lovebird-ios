//
//  LovebirdStatusCode.swift
//  LoveBird
//
//  Created by 황득연 on 2/18/24.
//

import Foundation

enum LovebirdStatusCode: Int {
  case success
  case badRequest = 400
  case internalServerError = 500

  init?(code: Int) {
    switch code {
      // 서버에서 값을 잘못주고 있어서 201도 포함시킨다.
    case 200, 201:
      self = .success

    case 400:
      self = .badRequest

    case 500:
      self = .internalServerError

    default:
      return nil
    }
  }
}
