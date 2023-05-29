//
//  String+Extension.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/28.
//

import Foundation

extension String {
    var isNicknameValid: Bool {
        let regEx = "^[ㄱ-ㅎ가-힣a-zA-Z]{0,}$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regEx)
        return predicate.evaluate(with: self)
    }
}

