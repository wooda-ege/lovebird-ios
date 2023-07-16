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
  case addSchedule(_ request: AddScheduleRequest)
  case fetchCalendars
  
  var method: HTTPMethod {
    switch self {
    case .signUp, .addSchedule:
      return .post
    case .fetchDiary, .searchPlace, .fetchCalendars:
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
    case .addSchedule, .fetchCalendars:
      return "calendar"
    }
  }
  
  var requestBody: Encodable? {
    switch self {
    case .signUp(let request as Encodable),
        .addSchedule(let request as Encodable),
        .fetchDiary(let request as Encodable),
        .searchPlace(let request as Encodable):
      return request
    default:
      return nil
    }
  }
}
