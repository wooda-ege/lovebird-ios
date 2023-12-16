//
//  UIScreen+Extension.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/20.
//

import UIKit

extension UIScreen {
  static var width: CGFloat {
    return Self.main.bounds.width
  }
  
  static var height: CGFloat {
    return Self.main.bounds.height
  }

  static var heightExceptSafeArea: CGFloat {
    return Self.main.bounds.height - (UIApplication.edgeInsets.top + UIApplication.edgeInsets.bottom)
  }
}
