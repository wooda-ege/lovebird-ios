//
//  LovebirdError.swift
//  LoveBird
//
//  Created by 황득연 on 2/18/24.
//

import Foundation

enum LovebirdError: Error {
  case badRequest(LovebirdAPIError)
  case decodeError
  case internalServerError
  case unknownError
}
