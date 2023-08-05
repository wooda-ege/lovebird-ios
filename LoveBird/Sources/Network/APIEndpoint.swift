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
  case kakaoLogin(_ request: KakaoLoginRequest)
  case appleLogin(_ request: AppleLoginRequest)
  
  var method: HTTPMethod {
    switch self {
    case .signUp:
      return .post
    case .fetchDiary:
      return .get
    case .searchPlace:
      return .get
    case .kakaoLogin:
      return .post
    case .appleLogin:
      return .post
    }
  }
  
  var path: String {
    switch self {
    case .signUp:
      return "/api/v1/profile"
    case .fetchDiary(let id):
      return "/members/\(id)"
    case .searchPlace(let searchTerm):
      return "/query=\(searchTerm)"
    case .kakaoLogin(let token):
      return "/api/v1/auth/kakao"
    case .appleLogin:
      return "/api/v1/auth/apple"
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
    case .kakaoLogin(let request):
      return request
    case .appleLogin(let request):
      return request
    default:
      return .none
    }
  }
}
