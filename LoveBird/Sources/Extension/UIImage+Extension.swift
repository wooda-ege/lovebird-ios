//
//  UIImage+Extension.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/27.
//

import UIKit

extension UIImage {
  static var shadowImage: UIImage {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = CGRect( x: 0, y: 0, width: UIScreen.width, height: 8)
    gradientLayer.colors = [
      UIColor.clear.cgColor,
      UIColor.black.withAlphaComponent(0.06).cgColor
    ]
    
    UIGraphicsBeginImageContext(gradientLayer.bounds.size)
    gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
  }
}
