//
//  NetworkStatusResponse.swift
//  LoveBird
//
//  Created by 황득연 on 12/9/23.
//

import Foundation

struct NetworkStatusResponse: Equatable {
  let code: String
  let message: String

  enum CodingKeys: String, CodingKey {
    case code
    case message
  }
}

extension NetworkStatusResponse: Decodable {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.code = try container.decode(String.self, forKey: .code)
    self.message = try container.decode(String.self, forKey: .message)
  }
}
