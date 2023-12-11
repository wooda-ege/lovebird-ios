//
//  ViewWidthKey.swift
//  LoveBird
//
//  Created by 황득연 on 12/10/23.
//

import SwiftUI

struct ViewWidthKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
