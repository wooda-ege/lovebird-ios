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

// Public인 DependencyKey 때문에 불가피하게 public으로 선언한다.
public enum APIClient {
  case signUp
  case fetchDiary(id :Int)
  case searchPlace(searchTerm: String)

  // profile
  case fetchProfile
  case editProfile(editProfile: EditProfileRequest)

  // diary
  case fetchDiaries

  // schedule
  case fetchCalendars
  case fetchSchedule(id: Int)
  case addSchedule(addSchedule: AddScheduleRequest)
  case editSchedule(id: Int, addSchedule: AddScheduleRequest)
  case deleteSchedule(Int)
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
      case .fetchProfile, .editProfile:
        return "profile"
      case .fetchSchedule(let id), .deleteSchedule(let id), .editSchedule(let id, _):
        return "calendar/\(id)"
      }
  }

  public var method: Moya.Method {
    switch self {
    case .signUp, .addSchedule:
      return .post
    case .fetchDiary, .searchPlace, .fetchCalendars, .fetchDiaries, .fetchProfile, .fetchSchedule:
      return .get
    case .editSchedule, .editProfile:
      return .put
    case .deleteSchedule:
      return .delete
    }
  }

  public var task: Moya.Task {
    switch self {
    case .addSchedule(let encodable), .editSchedule(_, let encodable):
      return .requestJSONEncodable(encodable as Encodable)
//      return .requestParameters(parameters: bodyParameters ?? [:], encoding: JSONEncoding.default)
    case .editProfile:
      return .uploadMultipart(self.multiparts)
    default:
      return .requestPlain
    }
  }

  // TODO: 토큰관련 수정할 것
  public var headers: [String: String]? {
    if true {
      return [
        "Authorization": "eyJhbGciOiJIUzUxMiJ9.eyJpZCI6IjIxNDc0ODM2NDciLCJleHAiOjE3MjE4ODI0ODd9.SkY9QmDQZ9ICU7LCeAKOQ4TGuDQOEmmwjplFpgxPVubLvJsng_heZ38LCXpDdjQ6mqGhtje8E9_XtKNmtjn9gA",
        "Refresh": "eyJhbGciOiJIUzUxMiJ9.eyJpZCI6IjIxNDc0ODM2NDciLCJleHAiOjE2OTE1NTYwODd9.k-eP6sIX0VFGWY_Lqt5iAl5ox-h54knkDhpfA8Mk75D22LYWNGQcjE-lRIU4v_RckRWtPi1ST-TP9__IH-nJ7Q",
        "Content-Type": "application/json"
      ]
    }
    return nil
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

  func requestRaw(_ target: Target) async throws -> NetworkStatusResponse {
    return try await withCheckedThrowingContinuation { continuation in
      self.request(target) { response in
        switch response {
        case .success(let result):
          do {
            let networkResponse = try JSONDecoder().decode(NetworkStatusResponse.self, from: result.data)
            continuation.resume(returning: networkResponse)
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
