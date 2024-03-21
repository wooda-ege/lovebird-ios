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
  case signUp(signUp: SignUpRequest)
  case withdrawal

  // profile
  case fetchProfile
  case editProfile(profile: EditProfileRequest)
  case presignProfileImage(presigned: PresignProfileImageRequest)
  case preuploadProfileImage(image: Data)

  // coupleLink
  case linkCouple(linkCouple: LinkCoupleRequest)
  case fetchCoupleCode
  case checkLinkedOrNot

  // diary
  case fetchDiaries
  case fetchDiary(id: Int)
  case addDiary(diary: AddDiaryRequest)
  case editDiary(id: Int, diary: AddDiaryRequest)
  case deleteDiary(id: Int)
  case searchPlaces(places: FetchPlacesRequest)
  case presignDiaryImages(presigned: PresignDiaryImagesRequest)
  case preuploadDiaryImages(images: [Data])

  // schedule
  case fetchCalendars(date: FetchSchedulesRequest)
  case fetchSchedule(id: Int)
  case addSchedule(schedule: AddScheduleRequest)
  case editSchedule(id: Int, schedule: AddScheduleRequest)
  case deleteSchedule(id: Int)

  var requestBody: Encodable? {
    switch self {
    case
        .signUp(let encodable as Encodable),
        .addSchedule(let encodable as Encodable),
        .editSchedule(_, let encodable as Encodable),
        .linkCouple(let encodable as Encodable),
        .authenticate(let encodable as Encodable),
        .editProfile(let encodable as Encodable),
        .addDiary(let encodable as Encodable),
        .editDiary(_, let encodable as Encodable),
        .presignProfileImage(let encodable as Encodable),
        .presignDiaryImages(let encodable as Encodable):
      return encodable

    default:
      return nil
    }
  }
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
      return "/auth/sign-in/oidc"

    case .fetchCoupleCode:
      return "/couple/code"

    case .linkCouple:
      return "/couple/link"

    case .checkLinkedOrNot:
      return "/couple/check"

    case .searchPlaces:
      return "/v2/local/search/keyword.json"

    case let .fetchDiary(id):
      return "/diaries/\(id)"

    case .fetchDiaries:
      return "/diaries"

    case .addDiary:
      return "/diaries"

    case let .editDiary(id, _), let .deleteDiary(id):
      return "/diaries/\(id)"

    case .addSchedule, .fetchCalendars:
      return "/calendars"

    case .fetchProfile, .editProfile:
      return "/profile"

    case .signUp:
      return "/auth/sign-up/oidc"

    case let .fetchSchedule(id), let .deleteSchedule(id), let .editSchedule(id, _):
      return "/calendars/\(id)"

    case .presignProfileImage:
      return "/presigned-urls/profile"

    case .presignDiaryImages:
      return "/presigned-urls/diary"

    case .preuploadDiaryImages:
      return "/images/diary"

    case .preuploadProfileImage:
      return "/images/profile"
    }
  }

  public var method: Moya.Method {
    switch self {
    case
        .signUp,
        .addSchedule,
        .authenticate,
        .addDiary,
        .presignProfileImage,
        .presignDiaryImages,
        .preuploadProfileImage,
        .preuploadDiaryImages:
      return .post

    case .fetchDiary, .fetchCalendars, .fetchDiaries, .fetchProfile,
        .fetchSchedule, .checkLinkedOrNot, .searchPlaces, .fetchCoupleCode:
      return .get

    case .editSchedule, .editDiary, .editProfile, .linkCouple:
      return .put

    case .deleteSchedule, .deleteDiary, .withdrawal:
      return .delete
    }
  }

  public var task: Moya.Task {
    switch self {
    case
        .signUp,
        .addSchedule,
        .editSchedule,
        .linkCouple,
        .authenticate,
        .editProfile,
        .addDiary,
        .editDiary,
        .presignProfileImage,
        .presignDiaryImages:
      if let body = requestBody {
        return .requestJSONEncodable(body)
      } else {
        return .requestPlain
      }

    case let .searchPlaces(encodable):
      return .requestParameters(parameters: ["query": encodable.query], encoding: URLEncoding.queryString)

    case .preuploadProfileImage, .preuploadDiaryImages:
      return .uploadMultipart(multiparts)

    default:
      return .requestPlain
    }
  }

  public var headers: [String: String]? {
    let accessToken = userData.accessToken.value
    let refreshToken =  userData.refreshToken.value
    print("Access Token is \(accessToken)")
    print("Refresh Token is \(refreshToken)")
    if case .searchPlaces = self {
      return ["Authorization" : Config.kakaoMapKey]
    }
    if accessToken.isNotEmpty, refreshToken.isNotEmpty  {
      return ["Authorization": "Bearer \(accessToken)", "Refresh": "Bearer \(refreshToken)"]
    }
    return nil
  }

  private var multiparts: [Moya.MultipartFormData] {
    var multiparts: [Moya.MultipartFormData] = []

    switch self {
    case let .preuploadProfileImage(image):
      let imageData = MultipartFormData(
        provider: .data(image),
        name: "image",
        fileName: "image.png",
        mimeType: "image/png"
      )
      multiparts.append(imageData)

    case let .preuploadDiaryImages(images):
      images.forEach {
        let imageData = MultipartFormData(
          provider: .data($0),
          name: "image",
          fileName: "image.png",
          mimeType: "image/png"
        )
        multiparts.append(imageData)
      }

    default:
      break
    }
    return multiparts
  }
}


extension MoyaProvider {
  func request<T: Decodable>(_ target: Target) async throws -> T? {
    return try await withCheckedThrowingContinuation { continuation in
      self.request(target) { response in
        switch response {
        case .success(let result):
          do {
            print("-----> Network Request (\(target.path))")
            if case let .requestJSONEncodable(requestBody) = target.task {
              print("\(String(describing: requestBody))")
            }

            switch LovebirdStatusCode(code: result.statusCode) {
            case .success:
              let data = try JSONDecoder().decode(NetworkResponse<T>.self, from: result.data)
              print("<----- Network Response (\(target.path))")
              print("\(String(describing: data.data))\n")
              continuation.resume(returning: data.data)

            case .badRequest:
              let data = try JSONDecoder().decode(NetworkStatusResponse.self, from: result.data)
              guard let errorType = LovebirdAPIError(rawValue: data.code) else {
                throw LovebirdError.unknownError
              }
              throw LovebirdError.badRequest(errorType: errorType, message: data.message)

            case .internalServerError:
              throw LovebirdError.internalServerError

            default:
              throw LovebirdError.unknownError
            }
          } catch {
            continuation.resume(throwing: error)
            print("<----- Network Failure: (\(target.path))")
            print("\(error)\n")
          }

        case .failure(let error):
          continuation.resume(throwing: error)
          print("<----- Network Failure: (\(target.path))")
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
            print("<----- Network Success (\(target.path))\n")
            print("\(networkResponse)\n")
          } catch {
            continuation.resume(throwing: error)
            print("<----- Network Exception: (\(target.path))")
            print("\(error)\n")
          }

        case .failure(let error):
          continuation.resume(throwing: error)
          print("<----- Network Exception: (\(target.path))")
          print("\(error)\n")
        }
      }
    }
  }
}
