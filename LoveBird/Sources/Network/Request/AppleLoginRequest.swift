//
//  AppleLoginRequest.swift
//  LoveBird
//
//  Created by 이예은 on 2023/07/17.
//

import Foundation

public struct AppleLoginRequest: Codable {
    let idToken: String
    let user: User
}

struct User: Codable {
    let email: String
    let name: Name
}

struct Name: Codable {
    let firstName, lastName: String
}
