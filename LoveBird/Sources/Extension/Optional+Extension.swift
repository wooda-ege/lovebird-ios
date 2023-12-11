//
//  Optional+Extension.swift
//  LoveBird
//
//  Created by 황득연 on 11/26/23.
//

import Foundation

extension Optional {
  var isNil: Bool { self == nil }
  var isNotNil: Bool { self != nil }
}

extension Optional where Wrapped == String {
  var isEmptyOrNil: Bool {
      return self?.isEmpty ?? true
  }

  var isNotEmpty: Bool {
      guard let self else { return false }
      return self.isNotEmpty
  }
}
