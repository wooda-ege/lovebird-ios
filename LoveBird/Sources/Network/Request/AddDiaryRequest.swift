//
//  RegisterDiaryRequest.swift
//  LoveBird
//
//  Created by 이예은 on 2023/08/15.
//

public struct AddDiaryRequest: Encodable {
  let title: String
  let memoryDate: String
  let place: String?
  let content: String
  let imageURLs: [String]?

  enum CodingKeys: String, CodingKey {
    case title
    case memoryDate
    case place
    case content
    case imageURLs = "imageUrls"
  }
}
