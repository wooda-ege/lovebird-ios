//
//  LovebirdAPI.swift
//  LoveBird
//
//  Created by 황득연 on 12/2/23.
//

import Foundation
import ComposableArchitecture
import Moya

typealias StatusCode = String

protocol LovebirdAPIProtocol {

  // auth
  func authenticate(auth: Authenticate) async throws -> Token
  func signUp(
    image: Data?,
    auth: Authenticate,
    profile: AddProfileRequest
  ) async throws -> Token

  func withdrawal() async throws -> StatusCode

  // profile
  func fetchProfile() async throws -> Profile
  func editProfile(image: Data?, profile: EditProfileRequest) async throws -> Profile
  func editProfileAnnivarsary(image: Data?, profile: EditProfileAnnivarsaryRequest) async throws -> Profile

  // coupleLink
  func linkCouple(linkCouple: LinkCoupleRequest) async throws -> StatusCode
  func fetchCoupleCode() async throws -> CoupleCode
  func checkIsLinked() async throws -> StatusCode

  // diary
  func fetchDiaries() async throws -> [Diary]
  func fetchDiary(id: Int) async throws -> Diary
  func addDiary(image: Data?, diary: AddDiaryRequest) async throws -> StatusCode
  func deleteDiary(id: Int) async throws -> StatusCode
  // TODO: 득연
  func fetchPlaces(places: FetchPlacesRequest) async throws -> [Place]

  // schedule
  func fetchCalendars() async throws -> [Schedule]
  // TODO: 득연
  func fetchSchedule(id: Int) async throws -> StatusCode
  func addSchedule(schedule: AddScheduleRequest) async throws -> StatusCode
  func editSchedule(id: Int, schedule: AddScheduleRequest) async throws -> StatusCode
  func deleteSchedule(id: Int) async throws -> StatusCode
}

struct LovebirdAPI: LovebirdAPIProtocol {
  let apiClient: MoyaProvider<APIClient>

  func authenticate(auth: Authenticate) async throws -> Token {
    try await apiClient.request(.authenticate(auth: auth)) as Token
  }
  
  func signUp(image: Data?, auth: Authenticate, profile: AddProfileRequest) async throws -> Token {
    try await apiClient.request(.signUp(image: image, auth: auth, signUp: profile))
  }
  
  func withdrawal() async throws -> StatusCode {
    try await apiClient.requestRaw(.withdrawal).status
  }
  
  func fetchProfile() async throws -> Profile {
    try await apiClient.request(.fetchProfile)
  }
  
  func editProfile(image: Data?, profile: EditProfileRequest) async throws -> Profile {
    try await apiClient.request(.editProfile(image: image, profile: profile))
  }
  
  func linkCouple(linkCouple: LinkCoupleRequest) async throws -> StatusCode {
    try await apiClient.requestRaw(.linkCouple(linkCouple: linkCouple)).status
  }
  
  func fetchCoupleCode() async throws -> CoupleCode {
    try await apiClient.request(.fetchCoupleCode)
  }
  
  func checkIsLinked() async throws -> StatusCode {
    try await apiClient.requestRaw(.checkIsLinked).status
  }
  
  func fetchDiaries() async throws -> [Diary] {
    let response = try await apiClient.request(.fetchDiaries) as FetchDiariesResponse
    return response.diaries
  }
  
  func fetchDiary(id: Int) async throws -> Diary {
    try await apiClient.request(.fetchDiary(id: id))
  }
  
  func addDiary(image: Data?, diary: AddDiaryRequest) async throws -> StatusCode {
    try await apiClient.requestRaw(.addDiary(image: image, diary: diary)).status
  }

  func editDiary(id: Int, image: Data?, diary: AddDiaryRequest) async throws -> StatusCode {
    try await apiClient.requestRaw(.editDiary(id: id, image: image, diary: diary)).status
  }

  func deleteDiary(id: Int) async throws -> StatusCode {
    try await apiClient.requestRaw(.deleteDiary(id: id)).status
  }
  
  func fetchPlaces(places: FetchPlacesRequest) async throws -> [Place] {
    let response = try await apiClient.request(.searchPlaces(places: places)) as FetchPlacesResponse
    return response.places
  }
  
  func fetchCalendars() async throws -> [Schedule] {
    let response = try await apiClient.request(.fetchCalendars) as FetchCalendarResponse
    return response.schedules
  }
  
  func fetchSchedule(id: Int) async throws -> StatusCode {
    try await apiClient.requestRaw(.fetchSchedule(id: id)).status
  }
  
  func addSchedule(schedule: AddScheduleRequest) async throws -> StatusCode {
    try await apiClient.requestRaw(.addSchedule(schedule: schedule)).status
  }
  
  func editSchedule(id: Int, schedule: AddScheduleRequest) async throws -> StatusCode {
    try await apiClient.requestRaw(.editSchedule(id: id, schedule: schedule)).status
  }
  
  func deleteSchedule(id: Int) async throws -> StatusCode {
    try await apiClient.requestRaw(.deleteSchedule(id: id)).status
  }

  func editProfileAnnivarsary(image: Data?, profile: EditProfileAnnivarsaryRequest) async throws -> Profile {
    try await apiClient.request(.editProfileAnnivarsary(image: image, profile: profile))
  }
}
