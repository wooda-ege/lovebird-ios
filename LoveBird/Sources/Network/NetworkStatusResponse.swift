//
//  NetworkStatusResponse.swift
//  LoveBird
//
//  Created by 황득연 on 12/9/23.
//

import Foundation

struct NetworkStatusResponse: Equatable {
  let status: String
  let message: String

  enum CodingKeys: String, CodingKey {
    case status
    case message
  }
}

extension NetworkStatusResponse: Decodable {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.status = try container.decode(String.self, forKey: .status)
    self.message = try container.decode(String.self, forKey: .message)
  }
}
