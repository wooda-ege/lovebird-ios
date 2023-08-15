//
//  Bundle+Extension.swift
//  LoveBird
//
//  Created by 황득연 on 2023/08/15.
//

import Foundation

extension Bundle {
  var version: String {
    return infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
  }
}
