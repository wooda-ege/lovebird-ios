//
//  StringResource+Extension.swift
//  LoveBird
//
//  Created by 황득연 on 2023/07/01.
//

import RswiftResources
import Foundation

extension StringResource {
  var value: String {
    self.developmentValue ?? ""
  }
}
