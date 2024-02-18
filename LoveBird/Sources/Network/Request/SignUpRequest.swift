//
//  SignUpRequest.swift
//  LoveBird
//
//  Created by 황득연 on 2/17/24.
//

public struct SignUpRequest {
  let provider: SNSProvider
  let deviceToken: String
  let imageUrl: String?
  let email: String?
  let nickname: String
  let birthday: String?
  let firstDate: String?
  let gender: String
  let idToken: String
}
