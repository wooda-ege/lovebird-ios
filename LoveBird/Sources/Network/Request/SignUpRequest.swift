//
//  SignUpRequest.swift
//  LoveBird
//
//  Created by 황득연 on 2023/06/04.
//

struct SignUpRequest: Encodable {
  let nickname: String
  let firstDate: String
  let gender: String? = nil
}
