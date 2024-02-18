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
  func editProfile(profile: EditProfileRequest) async throws -> Profile

  // coupleLink
  func linkCouple(linkCouple: LinkCoupleRequest) async throws -> Empty
  func fetchCoupleCode() async throws -> CoupleCode
  func checkIsLinked() async throws -> Empty

  // diary
  func fetchDiaries() async throws -> [Diary]
  func fetchDiary(id: Int) async throws -> Diary
  func addDiary(image: Data?, diary: AddDiaryRequest) async throws -> Empty
  func deleteDiary(id: Int) async throws -> Empty
  // TODO: 득연
  func fetchPlaces(places: FetchPlacesRequest) async throws -> [Place]

  // schedule
  func fetchCalendars() async throws -> [Schedule]
  // TODO: 득연
  func fetchSchedule(id: Int) async throws -> Empty
  func addSchedule(schedule: AddScheduleRequest) async throws -> Empty
  func editSchedule(id: Int, schedule: AddScheduleRequest) async throws -> Empty
  func deleteSchedule(id: Int) async throws -> Empty
}

struct LovebirdAPI: LovebirdAPIProtocol {
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

  func editProfile(profile: EditProfileRequest) async throws -> Profile {
    try await fetchOrThrow {
      try await apiClient.request(.editProfile(profile: profile)) as Profile?
    }
  }

  func linkCouple(linkCouple: LinkCoupleRequest) async throws -> Empty {
    try await performTaskWithoutResult {
      try await apiClient.request(.linkCouple(linkCouple: linkCouple))
    }
  }

  func fetchCoupleCode() async throws -> CoupleCode {
    try await fetchOrThrow {
      try await apiClient.request(.fetchCoupleCode) as CoupleCode?
    }
  }

  func checkIsLinked() async throws -> Empty {
    try await performTaskWithoutResult {
      try await apiClient.request(.checkIsLinked)
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

  func addDiary(image: Data?, diary: AddDiaryRequest) async throws -> Empty {
    try await performTaskWithoutResult {
      try await apiClient.request(.addDiary(image: image, diary: diary))
    }
  }

  func editDiary(id: Int, image: Data?, diary: AddDiaryRequest) async throws -> Empty {
    try await performTaskWithoutResult {
      try await apiClient.request(.editDiary(id: id, image: image, diary: diary))
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

  func fetchCalendars() async throws -> [Schedule] {
    try await fetchOrThrow {
      let response = try await apiClient.request(.fetchCalendars) as FetchCalendarResponse?
      return response?.schedules
    }
  }

  func fetchSchedule(id: Int) async throws -> Empty {
    try await performTaskWithoutResult {
      try await apiClient.request(.fetchSchedule(id: id))
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

  private func fetchOrThrow<T>(apiCall: @escaping () async throws -> T?) async throws -> T {
    guard let result = try await apiCall() else {
      throw LovebirdAPIError.emptyData
    }
    return result
  }

  func performTaskWithoutResult(apiCall: @escaping () async throws -> Empty?) async throws -> Empty {
    _ = try await apiCall()
    return Empty()
  }
}
