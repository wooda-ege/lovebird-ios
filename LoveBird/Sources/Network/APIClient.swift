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

public enum APIClient {

  // auth
  case authenticate(auth: Authenticate)
  case signUp(image: Data?, auth: Authenticate, signUp: AddProfileRequest)
  case withdrawal

  // profile
  case fetchProfile
  case editProfile(image: Data?, profile: EditProfileRequest)

  // coupleLink
  case linkCouple(linkCouple: LinkCoupleRequest)
  case fetchCoupleCode
  case checkIsLinked

  // diary
  case fetchDiaries
  case fetchDiary(id: Int)
  case addDiary(image: Data?, diary: AddDiaryRequest)
  case deleteDiary(id: Int)
  case searchPlaces(places: FetchPlacesRequest)

  // schedule
  case fetchCalendars
  case fetchSchedule(id: Int)
  case addSchedule(schedule: AddScheduleRequest)
  case editSchedule(id: Int, schedule: AddScheduleRequest)
  case deleteSchedule(id: Int)
}

extension APIClient: TargetType {

  public var userData: UserData {
    @Dependency(\.userData) var userData
    return userData
  }

  public var baseURL: URL {
    switch self {
    case .searchPlaces:
      return URL(string: Config.kakaoMapURL)!

    default:
      return URL(string: Config.baseURL)!
    }
  }

  public var path: String {
      switch self {
      case .withdrawal:
        return "/auth"

      case .authenticate:
        return "/auth/sign-in"

      case .fetchCoupleCode:
        return "/couple/code"

      case .linkCouple:
        return "/couple/link"

      case .checkIsLinked:
        return "/couple/check"

      case .searchPlaces:
        return "/v2/local/search/keyword.json"

      case .fetchDiary(let id):
        return "/members/\(id)"

      case .fetchDiaries, .addDiary:
        return "/diaries"

      case .deleteDiary(let id):
        return "/diaries/\(id)"

      case .addSchedule, .fetchCalendars:
        return "/calendar"
        
      case .fetchProfile, .editProfile, .editProfileAnnivarsary:
        return "/profile"
        
      case .signUp:
        return "/auth/sign-up"
        
      case .fetchSchedule(let id), .deleteSchedule(let id), .editSchedule(let id, _):
        return "/calendar/\(id)"
      }
  }

  public var method: Moya.Method {
    switch self {
    case .signUp, .addSchedule, .authenticate, .addDiary:
      return .post

    case .fetchDiary, .fetchCalendars, .fetchDiaries, .fetchProfile,
        .fetchSchedule, .checkIsLinked, .searchPlaces, .fetchCoupleCode:
      return .get

    case .editSchedule, .editProfile, .editProfileAnnivarsary, .linkCouple:
      return .put

    case .deleteSchedule, .deleteDiary, .withdrawal:
      return .delete
    }
  }

  public var task: Moya.Task {
    switch self {
    case .addSchedule(let encodable as Encodable),
        .editSchedule(_, let encodable as Encodable),
        .linkCouple(let encodable as Encodable),
        .authenticate(let encodable as Encodable),
        .searchPlaces(let encodable as Encodable):
      return .requestJSONEncodable(encodable)

      // MARK: - Multiparts

    case .editProfile, .addDiary, .signUp:
      return .uploadMultipart(self.multiparts)

    default:
      return .requestPlain
    }
  }
  
  public var headers: [String: String]? {
    let accessToken = self.userData.get(key: .accessToken, type: String.self)
    let refreshToken = self.userData.get(key: .refreshToken, type: String.self)
    if case .searchPlaces = self {
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
      if let image {
        multiparts.append(
          .init(
            provider: .data(image),
            name: "1-1",
            fileName: "1-1.png",
            mimeType: "image/png"
          )
        )
      }

    case .signUp(let image, let auth, let signUp):
      let auth = try! JSONEncoder().encode(auth)
      let signUp = try! JSONEncoder().encode(signUp)

      if let image {
        let imageData = MultipartFormData(
          provider: .data(image),
          name: "image",
          fileName: "image.png",
          mimeType: "image/png"
        )
        multiparts.append(imageData)
      }
      
      let signUpRequest = MultipartFormData(
        provider: .data(auth),
        name: "signUpRequest",
        mimeType: "application/json"
      )
      multiparts.append(signUpRequest)
      
      let profileRequest = MultipartFormData(
        provider: .data(signUp),
        name: "profileCreateRequest",
        mimeType: "application/json"
      )
      multiparts.append(profileRequest)

    case .addDiary(let image, let diary):
      let diary = try! JSONEncoder().encode(diary)

      if let image {
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
  
  func requestKakaoMap(_ target: Target) async throws -> FetchPlacesResponse {
    return try await withCheckedThrowingContinuation { continuation in
      self.request(target) { response in
        switch response {
        case .success(let result):
          do {
            let networkResponse = try JSONDecoder().decode(FetchPlacesResponse.self, from: result.data)
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
