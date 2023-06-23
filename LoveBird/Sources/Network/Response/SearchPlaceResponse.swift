//
//  SearchPlaceResponse.swift
//  LoveBird
//
//  Created by 이예은 on 2023/06/23.
//

import Foundation

struct SearchPlaceResponse: Decodable, Equatable, Sendable {
  let place: [PlaceInfo]
  
  enum CodingKeys: String, CodingKey {
    case place = "documents"
  }
}

// MARK: - Document
struct PlaceInfo: Decodable, Equatable, Sendable {
  let id: String
  let placeName: String
  let addressName: String
  
  enum CodingKeys: String, CodingKey {
    case placeName = "place_name"
    case id
    case addressName = "address_name"
  }
}
