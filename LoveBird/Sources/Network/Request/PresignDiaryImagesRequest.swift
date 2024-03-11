//
//  PresignDiaryImagesRequest.swift
//  LoveBird
//
//  Created by 황득연 on 3/4/24.
//

import Foundation

public struct PresignDiaryImagesRequest: Encodable, Equatable {
  let diaryId: Int?
  let fileNames: [String]

  enum CodingKeys: String, CodingKey {
    case diaryId
    case fileNames = "filenames"
  }
}
