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
  case registerProfile(authorization: String, refresh: String, image: UIImage?, profileRequest: RegisterProfileRequest)
  case fetchDiary(id :Int)
  case kakaoLogin(idToken: String, accessToken: String)
  case appleLogin(appleLoginRequest: AppleLoginRequest)
  case invitationViewLoaded(authorization: String, refresh: String)
  case coupleLinkButtonClicked(coupleCode: String, authorization: String, refresh: String)
  case coupleCheckButtonClicked(authorization: String, refresh: String)
  case searchKakaoMap(searchTerm: String)
  case registerDiary(authorization: String, refresh: String, image: UIImage?, diary: RegisterDiaryRequest)
  case searchPlace(searchTerm: String)

  // profile
  case fetchProfile(authorization: String, refresh: String)
  case editProfile(editProfile: EditProfileRequest)

  // diary
  case fetchDiaries(authorization: String, refresh: String)

  // schedule
  case fetchCalendars
  case fetchSchedule(id: Int)
  case addSchedule(addSchedule: AddScheduleRequest)
  case editSchedule(id: Int, addSchedule: AddScheduleRequest)
  case deleteSchedule(Int)
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
      case .kakaoLogin:
        return "/auth/kakao"
      case .appleLogin:
        return "/auth/apple"
      case .invitationViewLoaded:
        return "/couple/code"
      case .coupleLinkButtonClicked:
        return "/couple/link"
      case .coupleCheckButtonClicked:
        return "/couple/check"
      case .searchKakaoMap:
        return "/v2/local/search/keyword.json"
      case .registerDiary:
        return "/diaries"
      case .fetchDiary(let id):
        return "/members/\(id)"
      case .fetchDiaries:
        return "/diaries"
      case .searchPlace(let searchTerm):
        return "/query=\(searchTerm)"
      case .addSchedule, .fetchCalendars:
        return "/calendar"
      case .registerProfile, .fetchProfile, .editProfile:
        return "/profile"
      case .fetchSchedule(let id), .deleteSchedule(let id), .editSchedule(let id, _):
        return "/calendar/\(id)"
      }
  }

  public var method: Moya.Method {
    switch self {
    case .registerProfile, .addSchedule, .kakaoLogin, .appleLogin, .registerDiary:
      return .post
    case .fetchDiary, .searchPlace, .fetchCalendars, .fetchDiaries, .fetchProfile, .fetchSchedule, .invitationViewLoaded, .searchKakaoMap, .coupleCheckButtonClicked:
      return .get
    case .editSchedule, .editProfile, .coupleLinkButtonClicked:
      return .put
    case .deleteSchedule:
      return .delete
    }
  }

  public var task: Moya.Task {
    switch self {
    case .registerProfile(_, _, let image, let profileRequest):
      let profileData = try! JSONEncoder().encode(profileRequest)
      let imageData = MultipartFormData(provider: .data(image?.pngData() ?? Data()), name: "image", fileName: "image.png", mimeType: "image/png")
      let profileRequest = MultipartFormData(provider: .data(profileData), name: "profileCreateRequest", mimeType: "application/json")
      return .uploadMultipart([imageData, profileRequest])
    case .registerDiary(_, _, let image, let diary):
      let diary = try! JSONEncoder().encode(diary)
      let imageData = MultipartFormData(provider: .data(image?.pngData() ?? Data()), name: "1-1", fileName: "1-1.png", mimeType: "image/png")
      let diaryRequest = MultipartFormData(provider: .data(diary), name: "diaryCreateRequest", mimeType: "application/json")
      return .uploadMultipart([imageData, diaryRequest])
    case .kakaoLogin:
      return .requestParameters(parameters: self.bodyParameters ?? [:], encoding: JSONEncoding.default)
    case .appleLogin(let appleLoginRequest):
      return .requestJSONEncodable(appleLoginRequest as Encodable)
    case .searchKakaoMap:
      return .requestParameters(parameters: self.bodyParameters ?? [:], encoding: URLEncoding.queryString)
    case .coupleLinkButtonClicked:
      return .requestParameters(parameters: self.bodyParameters ?? [:], encoding: JSONEncoding.default)
    case .addSchedule(let encodable), .editSchedule(_, let encodable):
      return .requestJSONEncodable(encodable as Encodable)
    case .editProfile:
      return .uploadMultipart(self.multiparts)
    default:
      return .requestPlain
    }
  }
  
  // TODO: 토큰관련 수정할 것
  public var headers: [String: String]? {
    switch self {
    case .registerProfile(let authorization, let refresh, _, _):
      return ["Content-type" : "multipart/form-data", "Authorization": authorization,
              "Refresh": refresh]
    case .registerDiary(let authorization, let refresh, _, _):
      return ["Content-type" : "multipart/form-data", "Authorization": authorization,
              "Refresh": refresh]
    case .invitationViewLoaded(let authorization, let refresh):
      return ["Content-type" : "application/json", "Authorization": authorization,
              "Refresh": refresh]
    case .coupleLinkButtonClicked(_, let authorization, let refresh):
      return ["Content-type" : "application/json", "Authorization": authorization,
              "Refresh": refresh]
    case .coupleCheckButtonClicked(let authorization, let refresh):
      return ["Content-type" : "application/json", "Authorization": authorization,
              "Refresh": refresh]
    case .searchKakaoMap:
      return ["Content-type" : "application/json", "Authorization" : "KakaoAK 84c41aac97f944ac218cbb88d40b4db7"]
    case .fetchProfile(let authorization, let refresh):
      return ["Content-type" : "application/json", "Authorization": authorization,
              "Refresh": refresh]
    default:
      return ["Content-type" : "application/json"]
    }
    return nil
  }
  
  private var bodyParameters: Parameters? {
    var params: Parameters = [:]
    switch self {
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

  private var multiparts: [Moya.MultipartFormData] {
    var multiparts: [Moya.MultipartFormData] = []
    switch self {
    case .editProfile(let editProfile):
      multiparts.append(.init(provider: .data(editProfile.nickname?.data(using: .utf8) ?? Data()), name: "nickname"))
      multiparts.append(.init(provider: .data(editProfile.email?.data(using: .utf8) ?? Data()), name: "email"))
      multiparts.append(.init(provider: .data(editProfile.image ?? Data()), name: "images", fileName: "image.jpeg", mimeType: "image/jpeg"))
    default:
      break
    }
    return multiparts
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

