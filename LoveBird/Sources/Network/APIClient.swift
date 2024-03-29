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
  case editProfile(profile: EditProfileRequest)

  // coupleLink
  case linkCouple(linkCouple: LinkCoupleRequest)
  case fetchCoupleCode
  case checkIsLinked

  // diary
  case fetchDiaries
  case fetchDiary(id: Int)
  case addDiary(image: Data?, diary: AddDiaryRequest)
  case editDiary(id: Int, image: Data?, diary: AddDiaryRequest)
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

  // MARK: - Properties

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

      case let .fetchDiary(id):
        return "/diaries/\(id)"

      case .fetchDiaries, .addDiary:
        return "/diaries"

      case let .editDiary(id, _, _), let .deleteDiary(id):
        return "/diaries/\(id)"

      case .addSchedule, .fetchCalendars:
        return "/calendar"
        
      case .fetchProfile, .editProfile:
        return "/profile"
        
      case .signUp:
        return "/auth/sign-up"
        
      case let .fetchSchedule(id), let .deleteSchedule(id), let .editSchedule(id, _):
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

    case .editSchedule, .editDiary, .editProfile, .linkCouple:
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
        .editProfile(let encodable as Encodable):
      return .requestJSONEncodable(encodable)

    case let .searchPlaces(encodable):
      return .requestParameters(parameters: ["query": encodable.query], encoding: URLEncoding.queryString)

      // MARK: - Multiparts

    case .addDiary, .signUp, .editDiary:
      return .uploadMultipart(self.multiparts)

    default:
      return .requestPlain
    }
  }
  
  public var headers: [String: String]? {
    let accessToken = self.userData.get(key: .accessToken, type: String.self)
    let refreshToken = self.userData.get(key: .refreshToken, type: String.self)
    print("Access Token is \(accessToken ?? "None")")
    print("Refresh Token is \(refreshToken ?? "None")")
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

    case let .editDiary(_, image: image, diary: diary):
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
        name: "diaryUpdateRequest",
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
            print("<----- Network Success (\(target))")
            print("\(networkResponse.data)\n")
          } catch {
            continuation.resume(throwing: error)
            print("<----- Network Exception: (\(target))")
            print("\(error)\n")
          }

        case .failure(let error):
          continuation.resume(throwing: error)
          print("<----- Network Failure: (\(target))")
          print("\(error)\n")
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
            print("<----- Network Success (\(target))\n")
          } catch {
            continuation.resume(throwing: error)
            print("<----- Network Exception: (\(target))")
            print("\(error)\n")
          }
          
        case .failure(let error):
          continuation.resume(throwing: error)
          print("<----- Network Exception: (\(target))")
          print("\(error)\n")
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
            print("<----- Network Success (\(target))\n")
            print("\(networkResponse)\n")
          } catch {
            continuation.resume(throwing: error)
            print("<----- Network Exception: (\(target))")
            print("\(error)\n")
          }
          
        case .failure(let error):
          continuation.resume(throwing: error)
          print("<----- Network Exception: (\(target))")
          print("\(error)\n")
        }
      }
    }
  }
}
