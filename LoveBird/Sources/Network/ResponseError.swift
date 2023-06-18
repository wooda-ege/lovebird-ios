//
//  ResponseError.swift
//  LoveBird
//
//  Created by 황득연 on 2023/06/18.
//

import Foundation

// TODO: 차후에 서버와 토의 예정
enum ResponseError: Error {
  case decode
  case invalidURL
  case noResponse
  case unauthorized
  case unexpectedStatusCode
  case unknown
}
