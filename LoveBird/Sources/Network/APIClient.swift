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

  // onboarding
  case kakaoLogin(idToken: String, accessToken: String)
  case appleLogin(appleLoginRequest: AppleLoginRequest)
  case invitationViewLoaded
  case coupleLinkButtonClicked(coupleCode: String)
  case coupleCheckButtonClicked

  // profile
  case registerProfile(image: UIImage?, profileRequest: RegisterProfileRequest)
  case fetchProfile
  case editProfile(image: UIImage?, editProfile: EditProfileRequest)
  case withdrawal

  // diary
  case fetchDiaries
  case registerDiary(image: UIImage?, diary: RegisterDiaryRequest)
  case deleteDiary(id: Int)
  case fetchDiary(id: Int)
  case searchKakaoMap(searchTerm: String)

  // schedule
  case fetchCalendars
  case fetchSchedule(id: Int)
  case addSchedule(addSchedule: AddScheduleRequest)
  case editSchedule(id: Int, addSchedule: AddScheduleRequest)
  case deleteSchedule(Int)
}

extension APIClient: TargetType {

  public var userDate: UserData {
    @Dependency(\.userData) var userData
    return userData
  }

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
      case .withdrawal:
        return "/auth"
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
      case .deleteDiary(let id):
        return "/diaries/\(id)"
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
    case .fetchDiary, .fetchCalendars, .fetchDiaries, .fetchProfile,
        .fetchSchedule, .invitationViewLoaded, .searchKakaoMap, .coupleCheckButtonClicked:
      return .get
    case .editSchedule, .editProfile, .coupleLinkButtonClicked:
      return .put
    case .deleteSchedule, .deleteDiary, .withdrawal:
      return .delete
    }
  }

  public var task: Moya.Task {
    switch self {
    case .registerProfile(let image, let profileRequest):
      let profileData = try! JSONEncoder().encode(profileRequest)
      var multiparts: [Moya.MultipartFormData] = []

      if let image = image?.jpegData(compressionQuality: 0.5) {
        let imageData = MultipartFormData(
          provider: .data(image),
          name: "image",
          fileName: "image.png",
          mimeType: "image/png"
        )
        multiparts.append(imageData)
      }

      let profileRequest = MultipartFormData(
        provider: .data(profileData),
        name: "profileCreateRequest",
        mimeType: "application/json"
      )
      multiparts.append(profileRequest)

      return .uploadMultipart(multiparts)

    case .registerDiary(let image, let diary):
      let diary = try! JSONEncoder().encode(diary)

      var multiparts: [Moya.MultipartFormData] = []

      if let image = image?.jpegData(compressionQuality: 0.5) {
        let imageData = MultipartFormData(
          provider: .data(image),
          name: "images",
          fileName: "image.jpeg",
          mimeType: "image/jpeg"
        )
        multiparts.append(imageData)
      }

      let diaryRequest = MultipartFormData(
        provider: .data(diary),
        name: "diaryCreateRequest",
        mimeType: "application/json"
      )
      multiparts.append(diaryRequest)

      return .uploadMultipart(multiparts)

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
  
  public var headers: [String: String]? {
    let accessToken = self.userDate.get(key: .accessToken, type: String.self)
    let refreshToken = self.userDate.get(key: .refreshToken, type: String.self)
    if case .searchKakaoMap = self {
      return ["Authorization" : Config.kakaoMapKey]
    } else if let accessToken, let refreshToken  {
      return ["Authorization": accessToken, "Refresh": refreshToken]
    } else {
      return nil
    }
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
    case .coupleLinkButtonClicked(let coupleCode):
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
    case .editProfile(let image, let editProfileRequset):
      let editProfile = try! JSONEncoder().encode(editProfileRequset)
      multiparts.append(.init(provider: .data(editProfile), name: "profileUpdateRequest", mimeType: "application/json"))
      if let image = image?.pngData() {
        multiparts.append(.init(provider: .data(image), name: "1-1", fileName: "1-1.png", mimeType: "image/png"))
      }
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

