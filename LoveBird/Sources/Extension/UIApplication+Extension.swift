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
    let scenes = UIApplication.shared.connectedScenes
    let windowScene = scenes.first as? UIWindowScene
    let window = windowScene?.windows.first
    window?.endEditing(force)
  }
}

