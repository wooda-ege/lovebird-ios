//
//  Array+Extension.swift
//  LoveBird
//
//  Created by 황득연 on 1/7/24.
//

import Foundation

extension Array {
  subscript(safe index: Index) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }
  
  var center: Element? { self[safe: count / 2] ?? nil }
}
