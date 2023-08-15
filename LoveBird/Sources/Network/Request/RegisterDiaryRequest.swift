//
//  RegisterDiaryRequest.swift
//  LoveBird
//
//  Created by 이예은 on 2023/08/15.
//


public struct RegisterDiaryRequest: Encodable {
  let title: String
  let memoryDate: String
  let place: String
  let content: String
}
