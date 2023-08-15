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
import SwiftUI

// Public인 DependencyKey 때문에 불가피하게 public으로 선언한다.
public enum APIClient {
  case signUp(authorization: String, refresh: String, image: UIImage?, signUpRequest: SignUpRequest)
  case addSchedule(addSchedule: AddScheduleRequest)
  case fetchDiary(id :Int)
  case fetchCalendars
  case fetchDiaries
  case fetchProfile
  case kakaoLogin(idToken: String, accessToken: String)
  case appleLogin(appleLoginRequest: AppleLoginRequest)
  case invitationViewLoaded(authorization: String, refresh: String)
  case coupleLinkButtonClicked(coupleCode: String, authorization: String, refresh: String)
  case searchKakaoMap(searchTerm: String)
  case registerDiary(authorization: String, refresh: String, image: UIImage?, diary: RegisterDiaryRequest)
}

extension APIClient: TargetType {
  public var baseURL: URL {
    switch self {
    case .searchKakaoMap:
      return URL(string: Config.kakaoMapURL)!
    default:
      return URL(string: Config.baseURL)!
    }
  }
  
  public var path: String {
    switch self {
    case .signUp:
      return "/api/v1/profile"
    case .fetchDiary(let id):
      return "members/\(id)"
    case .fetchDiaries:
      return "diaries"
    case .addSchedule, .fetchCalendars:
      return "calendar"
    case .fetchProfile:
      return "/api/v1/profile"
    case .kakaoLogin:
      return "/api/v1/auth/kakao"
    case .appleLogin:
      return "/api/v1/auth/apple"
    case .invitationViewLoaded:
      return "/api/v1/couple/code"
    case .coupleLinkButtonClicked:
      return "/api/v1/couple/link"
    case .searchKakaoMap:
      return "/v2/local/search/keyword.json"
    case .registerDiary:
      return "/api/v1/diaries"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .signUp, .addSchedule, .kakaoLogin, .appleLogin, .registerDiary:
      return .post
    case .fetchDiary, .fetchCalendars, .fetchDiaries, .fetchProfile, .invitationViewLoaded, .searchKakaoMap:
      return .get
    case .coupleLinkButtonClicked:
      return .put
    }
  }
  
  public var task: Moya.Task {
    switch self {
    case .signUp(_, _, let image, let signUpRequest):
      let signUpData = try! JSONEncoder().encode(signUpRequest)
      let imageData = MultipartFormData(provider: .data(image?.pngData() ?? Data()), name: "image", fileName: "image.png", mimeType: "image/png")
      let signUpRequest = MultipartFormData(provider: .data(signUpData), name: "profileCreateRequest", mimeType: "application/json")
      return .uploadMultipart([imageData, signUpRequest])
    case .kakaoLogin:
      return .requestParameters(parameters: self.bodyParameters ?? [:], encoding: JSONEncoding.default)
    case .appleLogin(let appleLoginRequest):
      return .requestJSONEncodable(appleLoginRequest)
    case .searchKakaoMap:
      return .requestParameters(parameters: self.bodyParameters ?? [:], encoding: URLEncoding.queryString)
    case .coupleLinkButtonClicked:
      return .requestParameters(parameters: self.bodyParameters ?? [:], encoding: URLEncoding.queryString)
//    case .registerDiary(let image, let diary):
//      let encodedDiaryData = try! JSONEncoder().encode(diary)
//      let imageData = MultipartFormData(provider: .data(image?.pngData() ?? Data()), name: "1-1", fileName: "1-1.png", mimeType: "image/png")
//      let diaryData = MultipartFormData(provider: .data(encodedDiaryData), name: "diaryCreateRequest", mimeType: "application/json")
//      return .uploadMultipart([imageData, diaryData])
    default:
      return .requestPlain
    }
  }
  
  // TODO: 토큰관련 수정할 것
  public var headers: [String: String]? {
    switch self {
    case .signUp(let authorization, let refresh, _, _):
      return ["Content-type" : "multipart/form-data", "Authorization": authorization,
              "Refresh": refresh]
    case .appleLogin, .kakaoLogin:
      return ["Content-type" : "application/json"]
    case .invitationViewLoaded(let authorization, let refresh):
      return ["Content-type" : "application/json", "Authorization": authorization,
              "Refresh": refresh]
    case .coupleLinkButtonClicked(_, let authorization, let refresh):
      return ["Content-type" : "application/json", "Authorization": authorization,
              "Refresh": refresh]
    case .searchKakaoMap:
      return ["Content-type" : "application/json", "Authorization" : "KakaoAK 84c41aac97f944ac218cbb88d40b4db7"]
    case .registerDiary(let authorization, let refresh, let image, let diary):
      return ["Content-type" : "multipart/form-data", "Authorization": authorization,
              "Refresh": refresh]
    default:
      return ["Content-type" : "application/json",  "Authorization": "eyJhbGciOiJIUzUxMiJ9.eyJpZCI6IjIxNDc0ODM2NDciLCJleHAiOjE3MjE4ODI0ODd9.SkY9QmDQZ9ICU7LCeAKOQ4TGuDQOEmmwjplFpgxPVubLvJsng_heZ38LCXpDdjQ6mqGhtje8E9_XtKNmtjn9gA",
              "Refresh": "eyJhbGciOiJIUzUxMiJ9.eyJpZCI6IjIxNDc0ODM2NDciLCJleHAiOjE2OTE1NTYwODd9.k-eP6sIX0VFGWY_Lqt5iAl5ox-h54knkDhpfA8Mk75D22LYWNGQcjE-lRIU4v_RckRWtPi1ST-TP9__IH-nJ7Q"]
    }
    return nil
  }
  
  private var bodyParameters: Parameters? {
    var params: Parameters = [:]
    switch self {
      //    case .signUp(_, _, _, let signUpRequest):
      //      params["email"] = signUpRequest.email
      //      params["nickname"] = signUpRequest.nickname
      //      params["birthDay"] = signUpRequest.birthDay
      //      params["firstDate"] = signUpRequest.firstDate
      //      params["gender"] = signUpRequest.gender
      //      params["deviceToken"] = signUpRequest.deviceToken
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
    case .coupleLinkButtonClicked(let coupleCode, _, _):
      params["coupleCode"] = coupleCode
    case .searchKakaoMap(let searchTerm):
      params["query"] = searchTerm
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
  
  func requestRaw(_ target: Target) async throws -> String {
    return try await withCheckedThrowingContinuation { continuation in
      self.request(target) { response in
        switch response {
        case .success(let result):
          do {
            let networkResponse = try JSONDecoder().decode(NetworkStatusResponse.self, from: result.data)
            continuation.resume(returning: networkResponse.status)
          } catch {
            continuation.resume(throwing: error)
          }
          
        case .failure(let error):
          continuation.resume(throwing: error)
        }
      }
    }
  }
  
  func requestKakaoMap(_ target: Target) async throws -> [PlaceInfo] {
    return try await withCheckedThrowingContinuation { continuation in
      self.request(target) { response in
        switch response {
        case .success(let result):
          do {
            let networkResponse = try JSONDecoder().decode(SearchPlaceResponse.self, from: result.data)
            continuation.resume(returning: networkResponse.place)
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

