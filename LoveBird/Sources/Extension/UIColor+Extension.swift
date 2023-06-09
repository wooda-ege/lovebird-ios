//
//  UIColor+Extension.swift
//  LoveBird
//
//  Created by 이예은 on 2023/06/09.
//

import UIKit

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
    
    static var gray231: UIColor {
        return UIColor(r: 231, g: 231, b: 231)
    }
    
    static var gray122: UIColor {
        return UIColor(r: 122, g: 122, b: 122)
    }
}
