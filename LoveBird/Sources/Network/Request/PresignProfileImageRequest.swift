//
//  PresignProfileImageRequest.swift
//  LoveBird
//
//  Created by 황득연 on 2/18/24.
//

import Foundation

public struct PresignProfileImageRequest: Encodable, Equatable {
  let fileName: String

  enum CodingKeys: String, CodingKey {
    case fileName = "filename"
  }
}
