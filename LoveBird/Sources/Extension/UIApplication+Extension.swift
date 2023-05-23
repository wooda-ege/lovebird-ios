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
    
    static func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

}
