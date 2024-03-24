//
//  LovebirdError.swift
//  LoveBird
//
//  Created by 황득연 on 2/18/24.
//

import Foundation

enum LovebirdError: Error {
  case badRequest(errorType: LovebirdAPIError, message: String)
  case decodeError
  case internalServerError
  case unknownError
  case invalidHTTPResponseError
  case noReceivedDataError
  case unableToCreateURLError
}
