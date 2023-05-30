//
//  Calendar+Extension.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/29.
//

import Foundation

extension Calendar {
    static var year: Int {
        return self.current.component(.year, from: Date())
    }
    
    static var month: Int {
        return self.current.component(.month, from: Date())
    }
    
    static var day: Int {
        return self.current.component(.day, from: Date())
    }
}
