//
//  LottieAnimation+Extension.swift
//  LoveBird
//
//  Created by 황득연 on 3/1/24.
//

import Foundation
import Lottie

extension LottieAnimation {
    static func from(asset: LoveBirdData) -> LottieAnimation? {
        return try? JSONDecoder().decode(LottieAnimation.self, from: asset.data.data)
    }
}
