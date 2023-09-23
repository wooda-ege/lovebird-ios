//
//  SignUpRequest.swift
//  LoveBird
//
//  Created by 황득연 on 2023/06/04.
//

public struct RegisterProfileRequest: Encodable {
  let email: String
  let nickname: String
  let birthDay: String?
  let firstDate: String?
  let gender: String
  let deviceToken: String
}
