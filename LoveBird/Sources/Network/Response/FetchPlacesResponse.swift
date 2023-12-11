//
//  SearchPlaceResponse.swift
//  LoveBird
//
//  Created by 이예은 on 2023/06/23.
//

import Foundation

struct FetchPlacesResponse: Decodable, Equatable, Sendable {
  let places: [Place]

  enum CodingKeys: String, CodingKey {
    case places = "documents"
  }
}

// MARK: - Document
struct Place: Decodable, Equatable, Sendable {
  let id: String
  let placeName: String
  let addressName: String
  
  enum CodingKeys: String, CodingKey {
    case placeName = "place_name"
    case id
    case addressName = "address_name"
  }
}
