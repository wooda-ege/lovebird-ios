//
//  LovebirdAPI.swift
//  LoveBird
//
//  Created by 황득연 on 12/2/23.
//

import Foundation
import ComposableArchitecture
import Moya

protocol LovebirdAPIProtocol {

  // auth
  func authenticate(auth: Authenticate) async throws -> Token
  func signUp(signUp: SignUpRequest) async throws -> Token
  func withdrawal() async throws -> Empty

  // profile
  func fetchProfile() async throws -> Profile
  func editProfile(profile: EditProfileRequest) async throws -> Empty
  func presignProfileImage(presigned: PresignProfileImageRequest) async throws -> PresignImageResponse
  func preuploadProfileImage(image: Data) async throws -> PreuploadImageResponse

  // coupleLink
  func linkCouple(linkCouple: LinkCoupleRequest) async throws -> LinkCoupleResponse
  func fetchCoupleCode() async throws -> CoupleCode
  func checkLinkedOrNot() async throws -> CheckLinkedOrNotResponse

  // diary
  func fetchDiaries() async throws -> [Diary]
  func fetchDiary(id: Int) async throws -> Diary
  func addDiary(diary: AddDiaryRequest) async throws -> Empty
  func deleteDiary(id: Int) async throws -> Empty
  func fetchPlaces(places: FetchPlacesRequest) async throws -> [Place]
  func presignDiaryImages(presigned: PresignDiaryImagesRequest) async throws -> PresignImagesResponse
  func preuploadDiaryImages(images: [Data]) async throws -> PreuploadImagesResponse

  // schedule
  func fetchCalendars(date: FetchSchedulesRequest) async throws -> [Schedule]
  func fetchSchedule(id: Int) async throws -> Schedule
  func addSchedule(schedule: AddScheduleRequest) async throws -> Empty
  func editSchedule(id: Int, schedule: AddScheduleRequest) async throws -> Empty
  func deleteSchedule(id: Int) async throws -> Empty
}

struct LovebirdAPI: LovebirdAPIProtocol {

  @Dependency(\.toastController) var toastController

  let apiClient: MoyaProvider<APIClient>

  func authenticate(auth: Authenticate) async throws -> Token {
    try await fetchOrThrow {
      return try await apiClient.request(.authenticate(auth: auth)) as Token?
    }
  }

  func signUp(signUp: SignUpRequest) async throws -> Token {
    try await fetchOrThrow {
      try await apiClient.request(.signUp(signUp: signUp)) as Token?
    }
  }

  func withdrawal() async throws -> Empty {
    try await performTaskWithoutResult {
      try await apiClient.request(.withdrawal)
    }
  }

  func fetchProfile() async throws -> Profile {
    try await fetchOrThrow {
      try await apiClient.request(.fetchProfile) as Profile?
    }
  }

  func editProfile(profile: EditProfileRequest) async throws -> Empty {
    try await performTaskWithoutResult {
      try await apiClient.request(.editProfile(profile: profile))
    }
  }

  func linkCouple(linkCouple: LinkCoupleRequest) async throws -> LinkCoupleResponse {
    try await fetchOrThrow {
      try await apiClient.request(.linkCouple(linkCouple: linkCouple)) as LinkCoupleResponse?
    }
  }

  func fetchCoupleCode() async throws -> CoupleCode {
    try await fetchOrThrow {
      try await apiClient.request(.fetchCoupleCode) as CoupleCode?
    }
  }

  func checkLinkedOrNot() async throws -> CheckLinkedOrNotResponse {
    try await fetchOrThrow {
      try await apiClient.request(.checkLinkedOrNot)
    }
  }

  func fetchDiaries() async throws -> [Diary] {
    try await fetchOrThrow {
      let response = try await apiClient.request(.fetchDiaries) as FetchDiariesResponse?
      return response?.diaries
    }
  }

  func fetchDiary(id: Int) async throws -> Diary {
    try await fetchOrThrow {
      try await apiClient.request(.fetchDiary(id: id)) as Diary?
    }
  }

  func addDiary(diary: AddDiaryRequest) async throws -> Empty {
    try await performTaskWithoutResult {
      try await apiClient.request(.addDiary(diary: diary))
    }
  }

  func editDiary(id: Int, diary: AddDiaryRequest) async throws -> Empty {
    try await performTaskWithoutResult {
      try await apiClient.request(.editDiary(id: id, diary: diary))
    }
  }

  func deleteDiary(id: Int) async throws -> Empty {
    try await performTaskWithoutResult {
      try await apiClient.request(.deleteDiary(id: id))
    }
  }

  func fetchPlaces(places: FetchPlacesRequest) async throws -> [Place] {
    try await fetchOrThrow {
      let response = try await apiClient.requestKakaoMap(.searchPlaces(places: places)) as FetchPlacesResponse?
      return response?.places
    }
  }

  func fetchCalendars(date: FetchSchedulesRequest = .init()) async throws -> [Schedule] {
    try await fetchOrThrow {
      let response = try await apiClient.request(.fetchCalendars(date: date)) as FetchCalendarResponse?
      return response?.schedules
    }
  }

  func fetchSchedule(id: Int) async throws -> Schedule {
    try await fetchOrThrow {
      try await apiClient.request(.fetchSchedule(id: id)) as Schedule?
    }
  }

  func addSchedule(schedule: AddScheduleRequest) async throws -> Empty {
    try await performTaskWithoutResult {
      try await apiClient.request(.addSchedule(schedule: schedule))
    }
  }

  func editSchedule(id: Int, schedule: AddScheduleRequest) async throws -> Empty {
    try await performTaskWithoutResult {
      try await apiClient.request(.editSchedule(id: id, schedule: schedule))
    }
  }

  func deleteSchedule(id: Int) async throws -> Empty {
    try await performTaskWithoutResult {
      try await apiClient.request(.deleteSchedule(id: id))
    }
  }

  func presignProfileImage(presigned: PresignProfileImageRequest) async throws -> PresignImageResponse {
    try await fetchOrThrow {
      try await apiClient.request(.presignProfileImage(presigned: presigned))
    }
  }

  func preuploadProfileImage(image: Data) async throws -> PreuploadImageResponse {
    try await fetchOrThrow {
      try await apiClient.request(.preuploadProfileImage(image: image))
    }
  }

  func presignDiaryImages(presigned: PresignDiaryImagesRequest) async throws -> PresignImagesResponse {
    try await fetchOrThrow {
      try await apiClient.request(.presignDiaryImages(presigned: presigned))
    }
  }

  func preuploadDiaryImages(images: [Data]) async throws -> PreuploadImagesResponse {
    try await fetchOrThrow {
      try await apiClient.request(.preuploadDiaryImages(images: images))
    }
  }
}

// MARK: - Wrapper

extension LovebirdAPI {
  private func fetchOrThrow<T>(apiCall: @escaping () async throws -> T?) async throws -> T {
    do {
      guard let result = try await apiCall() else {
        throw LovebirdAPIError.emptyData
      }
      return result
    } 
    catch {
      await handleNetworkErrorIfNeeded(error: error)
      throw error
    }
  }

  private func performTaskWithoutResult(apiCall: @escaping () async throws -> Empty?) async throws -> Empty {
    do {
      _ = try await apiCall()
      return Empty()
    }
    catch {
      await handleNetworkErrorIfNeeded(error: error)
      throw error
    }
  }

  private func handleNetworkErrorIfNeeded(error: Error) async {
    if let error = error as? MoyaError, case let .underlying(error, _) = error {
      if error.asAFError?.isSessionTaskError == true {
        await toastController.showToast(message: "네트워크가 불안정합니다. 다시 시도해주세요")
      }
    }
  }
}
