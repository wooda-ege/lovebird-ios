//
//  APIClient.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/30.
//

import Moya
import Alamofire
import ComposableArchitecture
import Dependencies
import Alamofire
import UIKit

// Public인 DependencyKey 때문에 불가피하게 public으로 선언한다.
public enum APIClient {
  case signUp(authorization: String, refresh: String, signUpRequest: SignUpRequest)
  case addSchedule(addSchedule: AddScheduleRequest)
  case fetchDiary(id :Int)
  case searchPlace(searchTerm: String)
  case fetchCalendars
  case fetchDiaries
  case fetchProfile
  case kakaoLogin(idToken: String, accessToken: String)
  case appleLogin(appleLoginRequest: AppleLoginRequest)
}

extension APIClient: TargetType {

  public var baseURL: URL {
    URL(string: Config.baseURL)!
  }

  public var path: String {
      switch self {
      case .signUp:
        return "members"
      case .fetchDiary(let id):
        return "members/\(id)"
      case .fetchDiaries:
        return "diaries"
      case .searchPlace(let searchTerm):
        return "query=\(searchTerm)"
      case .addSchedule, .fetchCalendars:
        return "calendar"
      case .fetchProfile:
        return "profile"
      case .kakaoLogin:
        return "/api/v1/auth/kakao"
      case .appleLogin:
        return "/api/v1/auth/apple"
      }
  }
  
  public var method: Moya.Method {
    switch self {
    case .signUp, .addSchedule:
      return .post
    case .fetchDiary, .searchPlace, .fetchCalendars, .fetchDiaries, .fetchProfile:
      return .get
    case .kakaoLogin:
      return .post
    case .appleLogin:
      return .post
    }
  }
  
  public var task: Moya.Task {
    switch self {
    case .signUp:
      return .requestParameters(parameters: self.bodyParameters ?? [:], encoding: JSONEncoding.default)
    case .kakaoLogin:
      return .requestParameters(parameters: self.bodyParameters ?? [:], encoding: JSONEncoding.default)
    case .appleLogin:
      return .requestParameters(parameters: self.bodyParameters ?? [:], encoding: JSONEncoding.default)
    default:
      return .requestPlain
    }
  }

  // TODO: 토큰관련 수정할 것
  public var headers: [String: String]? {
    if true {
      return [
        "Authorization": "eyJhbGciOiJIUzUxMiJ9.eyJpZCI6IjIxNDc0ODM2NDciLCJleHAiOjE3MjE4ODI0ODd9.SkY9QmDQZ9ICU7LCeAKOQ4TGuDQOEmmwjplFpgxPVubLvJsng_heZ38LCXpDdjQ6mqGhtje8E9_XtKNmtjn9gA",
        "Refresh": "eyJhbGciOiJIUzUxMiJ9.eyJpZCI6IjIxNDc0ODM2NDciLCJleHAiOjE2OTE1NTYwODd9.k-eP6sIX0VFGWY_Lqt5iAl5ox-h54knkDhpfA8Mk75D22LYWNGQcjE-lRIU4v_RckRWtPi1ST-TP9__IH-nJ7Q"
      ]
    }
    return nil
  }

  private var bodyParameters: Parameters? {
    var params: Parameters = [:]
    switch self {
    case .signUp(let authorization, let refresh, let signUpRequest):
//      let email: String
//      let nickname: String
//      let birthDay: String
//      let firstDate: String
//      let gender: String
//      let deviceToken: String
      params["email"] = signUpRequest.email
      params["nickname"] = signUpRequest.nickname
      params["birthDay"] = signUpRequest.birthDay
      params["firstDate"] = signUpRequest.firstDate
      params["gender"] = signUpRequest.gender
      params["deviceToken"] = signUpRequest.deviceToken
    case .addSchedule(let addSchedule):
      params["title"] = addSchedule.title
      params["memo"] = addSchedule.memo
      params["color"] = addSchedule.color
      params["startDate"] = addSchedule.startDate
      params["endDate"] = addSchedule.endDate
      params["startTime"] = addSchedule.startTime
      params["endTime"] = addSchedule.endTime
      params["alarm"] = addSchedule.alarm
    case .kakaoLogin(let idToken, let accessToken):
      params["idToken"] = idToken
      params["accessToken"] = accessToken
    case .appleLogin(let appleLoginRequest):
      params["idToken"] = appleLoginRequest.idToken
      params["user"] = appleLoginRequest.user
    default:
      break
    }
    return params
  }
}

extension MoyaProvider {
  func request<T: Decodable>(_ target: Target) async throws -> T {
    return try await withCheckedThrowingContinuation { continuation in
      self.request(target) { response in
        switch response {
        case .success(let result):
          do {
            let networkResponse = try JSONDecoder().decode(NetworkResponse<T>.self, from: result.data)
            continuation.resume(returning: networkResponse.data)
          } catch {
            continuation.resume(throwing: error)
          }

        case .failure(let error):
          continuation.resume(throwing: error)
        }
      }
    }
  }
}

extension DependencyValues {
  var apiClient: MoyaProvider<APIClient> {
    get { self[MoyaProvider.self] }
    set { self[MoyaProvider.self] = newValue }
  }
}

extension MoyaProvider<APIClient>: DependencyKey, TestDependencyKey {
  public static var liveValue = MoyaProvider<APIClient>()
}
