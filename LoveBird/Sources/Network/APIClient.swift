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
  case kakaoLogin(kakaoLoginRequest: KakaoLoginRequest)
  case appleLogin(appleLoginRequest: AppleLoginRequest)
  case invitationViewLoaded

  // coupleLink
  case linkCouple(linkCoupleRequest: LinkCoupleRequest)
  case fetchCoupleCode

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

      case .linkCouple:
        return "/couple/link"

      case .fetchCoupleCode:
        return "/couple/check"

      case .searchKakaoMap:
        return "/v2/local/search/keyword.json"

      case .fetchDiary(let id):
        return "/members/\(id)"

      case .fetchDiaries, .registerDiary:
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
        .fetchSchedule, .invitationViewLoaded, .searchKakaoMap, .fetchCoupleCode:
      return .get

    case .editSchedule, .editProfile, .linkCouple:
      return .put

    case .deleteSchedule, .deleteDiary, .withdrawal:
      return .delete
    }
  }

  public var task: Moya.Task {
    switch self {
    case .searchKakaoMap(let searchTerm):
      return .requestParameters(
        parameters: ["query": searchTerm],
        encoding: URLEncoding.queryString
      )

    case
        .kakaoLogin(let encodable as Encodable),
        .appleLogin(let encodable as Encodable),
        .addSchedule(let encodable as Encodable),
        .editSchedule(_, let encodable as Encodable),
        .linkCouple(let encodable as Encodable):
      return .requestJSONEncodable(encodable)

      // MARK: - Multiparts

    case .editProfile, .registerDiary, .registerProfile:
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
    } 
    if let accessToken, let refreshToken  {
      return ["Authorization": accessToken, "Refresh": refreshToken]
    }
    return nil
  }

  private var multiparts: [Moya.MultipartFormData] {
    var multiparts: [Moya.MultipartFormData] = []

    switch self {
    case .editProfile(let image, let editProfileRequset):
      let editProfile = try! JSONEncoder().encode(editProfileRequset)
      multiparts.append(
        .init(
          provider: .data(editProfile),
          name: "profileUpdateRequest",
          mimeType: "application/json"
        )
      )
      if let image = image?.pngData() {
        multiparts.append(
          .init(
            provider: .data(image),
            name: "1-1",
            fileName: "1-1.png",
            mimeType: "image/png"
          )
        )
      }

    case .registerProfile(let image, let profileRequest):
      let profileData = try! JSONEncoder().encode(profileRequest)

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

    case .registerDiary(let image, let diary):
      let diary = try! JSONEncoder().encode(diary)

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

