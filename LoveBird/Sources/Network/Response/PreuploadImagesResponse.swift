//
//  PreuploadImagesResponse.swift
//  LoveBird
//
//  Created by 황득연 on 3/18/24.
//

import Foundation

struct PreuploadImagesResponse: Decodable {
  let fileUrls: [PreuploadImageResponse]
  let totalCount: Int
}
