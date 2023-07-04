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
  
  var isEmailValid: Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    
    return emailPred.evaluate(with: self)
  }
  
  var isNotEmpty: Bool {
    return !self.isEmpty
  }
}

