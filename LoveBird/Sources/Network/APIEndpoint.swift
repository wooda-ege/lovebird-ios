//
//  APIEndpoint.swift
//  LoveBird
//
//  Created by 황득연 on 2023/06/06.
//

enum APIEndpoint {
  
  enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
  }
  
  case signUp(_ request: SignUpRequest)
  case fetchDiary(_ request: DiaryRequest)
  
  var method: HTTPMethod {
    switch self {
    case .signUp:
      return .post
    case .fetchDiary:
      return .get
    }
  }
  
  var path: String {
    switch self {
    case .signUp:
      return "members"
    case .fetchDiary(let id):
      return "members/\(id)"
    }
  }
  
  var requestBody: Encodable? {
    switch self {
    case .signUp(let request):
      return request
    case .fetchDiary(let request):
      return request
    }
  }
}
