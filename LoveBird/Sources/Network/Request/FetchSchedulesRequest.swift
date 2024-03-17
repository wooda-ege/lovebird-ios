//
//  FetchSchedulesRequest.swift
//  LoveBird
//
//  Created by 황득연 on 2/25/24.
//

import Foundation

public struct FetchSchedulesRequest: Encodable {

  init(year: String? = nil, month: String? = nil) {
    self.year = year
    self.month = month
  }

  let year: String?
  let month: String?
}
