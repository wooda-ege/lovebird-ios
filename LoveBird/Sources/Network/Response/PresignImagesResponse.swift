//
//  PresignImagesResponse.swift
//  LoveBird
//
//  Created by 황득연 on 3/4/24.
//

import Foundation

struct PresignImagesResponse: Decodable, Equatable {
  let presignedURLs: [PresignImageResponse]
  let totalCount: Int

  enum CodingKeys: String, CodingKey {
    case presignedURLs = "presignedUrls"
    case totalCount
  }
}
