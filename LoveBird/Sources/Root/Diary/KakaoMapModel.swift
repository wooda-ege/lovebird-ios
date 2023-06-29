//
//  KakaoMapModel.swift
//  LoveBird
//
//  Created by 이예은 on 2023/05/31.
//


import SwiftUI

struct KaKaoMap: Decodable {
  let place: [PlaceInfo]
  
  enum CodingKeys: String, CodingKey {
    case place = "documents"
  }
}

// MARK: - Document
struct PlaceInfo: Decodable, Equatable {
  let id: String
  let placeName: String
  
  enum CodingKeys: String, CodingKey {
    case placeName = "place_name"
    case id
  }
}

