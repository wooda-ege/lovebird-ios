//
//  PresignImageResponse.swift
//  LoveBird
//
//  Created by 황득연 on 2/18/24.
//

import Foundation

struct PresignImageResponse: Decodable, Equatable {
  let presignedURL: String
  let fileName: String

  enum CodingKeys: String, CodingKey {
    case presignedURL = "presignedUrl"
    case fileName = "filename"
  }
}
