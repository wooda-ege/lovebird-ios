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
  case searchPlace(_ request: PlaceRequest)
  
  var method: HTTPMethod {
    switch self {
    case .signUp:
      return .post
    case .fetchDiary:
      return .get
    case .searchPlace:
      return .get
    }
  }
  
  var path: String {
    switch self {
    case .signUp:
      return "members"
    case .fetchDiary(let id):
      return "members/\(id)"
    case .searchPlace(let searchTerm):
      return "query=\(searchTerm)"
    }
  }
  
  var requestBody: Encodable? {
    switch self {
    case .signUp(let request):
      return request
    case .fetchDiary(let request):
      return request
    case .searchPlace(let request):
      return request
    }
  }
}
