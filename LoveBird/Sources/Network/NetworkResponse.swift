//
//  NetworkResponse.swift
//  LoveBird
//
//  Created by 황득연 on 2023/06/06.
//

import Foundation

struct NetworkResponse<T> {
  let code: String
  let message: String
  let data: T
  
  enum CodingKeys: String, CodingKey {
    case status
    case message
    case data
  }
}

extension NetworkResponse: Decodable where T: Decodable {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.code = try container.decode(String.self, forKey: .status)
    self.message = try container.decode(String.self, forKey: .message)
    self.data = try container.decode(T.self, forKey: .data)
  }
}
