//
//  UIApplication+Extension.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/21.
//

import UIKit

extension UIApplication {
  static var edgeInsets: UIEdgeInsets {
    let scene = Self.shared.connectedScenes.first as? UIWindowScene
    return scene?.windows.first?.safeAreaInsets ?? .zero
  }
  
  func endEditing(_ force: Bool) {
    self.windows
      .filter{$0.isKeyWindow}
      .first?
      .endEditing(force)
  }
}

