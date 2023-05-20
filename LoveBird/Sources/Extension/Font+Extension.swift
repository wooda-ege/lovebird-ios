//
//  Font+Extension.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/20.
//

import SwiftUI

extension Font {
    enum PretendardWeight: String {
        case bold = "Bold"
        case regular = "Regular"
        case semiBold = "SemiBold"
    }
    
    static func pretendard(size: CGFloat, weight: PretendardWeight) -> Font {
        return Font.custom("Pretendard-\(weight.rawValue)", size: size)
    }
}
