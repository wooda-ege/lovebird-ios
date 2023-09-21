//
//  SimpleDate.swift
//  LoveBird
//
//  Created by 황득연 on 2023/09/17.
//

import Foundation

struct SimpleDate: Equatable {
  var year: Int = Date().year
  var month: Int = Date().month
  var day: Int = Date().day

  func toYMDFormat() -> String {
    String(format: "%04d-%02d-%02d", self.year, self.month, self.day)
  }
}
