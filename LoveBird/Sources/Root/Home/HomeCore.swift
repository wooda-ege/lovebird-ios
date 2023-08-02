//
//  HomeCore.swift
//  wooda
//
//  Created by 황득연 on 2023/05/09.
//

import Foundation
import ComposableArchitecture
import Combine

struct HomeCore: ReducerProtocol {
  
  struct State: Equatable {
    var diarys: [Diary] = Diary.dummy
    var offsetY: CGFloat = 0.0
  }
  
  enum Action: Equatable {
    case diaryTitleTapped(Diary)
    case diaryTapped(Diary)
    case emptyDiaryTapped
    case searchTapped
    case listTapped
    case notificationTapped
    case offsetYChanged(CGFloat)

    // Network
    case fetchDiaries
    case fetchUserInfo
    case loadData
    case diariesResponse(TaskResult<NetworkStatusResponse>)
    case userInfoResponse(TaskResult<FetchProfileResponse>)
    case response(FetchDiariesResponse, FetchProfileResponse)
    case dataLoaded(FetchDiariesResponse, FetchDiariesResponse)
  }

  @Dependency(\.apiClient) var apiClient

  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .diaryTitleTapped(let diary):
        if let idx = state.diarys.firstIndex(where: { $0.id == diary.id }) {
          state.diarys[idx].type.toggle()
        }
      case .loadData:
        return EffectTask.run { send in
          Task {
            async let diariesResponse = apiClient.request(.fetchDiaries) as FetchDiariesResponse
//            async let userInfoResponse = apiClient.request(.fetchProfile) as FetchProfileResponse
            print("------------------")
            try await print(diariesResponse)
//            try await print(userInfoResponse)
            print("------------------")

            let result = try await (diariesResponse, diariesResponse)
            await send(.dataLoaded(result.0, result.1))
          }
        }

      case .dataLoaded(let diary, let info):
        print("------------------")
        print(diary)
        print(info)
        print("------------------")
      case .diaryTapped(let diary):
        return .none //TODO: 득연 - Navigation
      case .offsetYChanged(let y):
        state.offsetY = y

        // MARK: - Network
      case .loadData:
//        let diariesTask = await self.apiClient.requestRaw(.fetchDiaries)
//        let profileTask = await self.apiClient.request(.fetchProfile) as FetchProfileResponse
        return .concatenate(
          .task {
              .diariesResponse(
                await TaskResult {
                  try await self.apiClient.requestRaw(.fetchDiaries)
                }
              )
          },
          .task {
              .diariesResponse(
                await TaskResult {
                  try await self.apiClient.requestRaw(.fetchDiaries)
                }
              )
          }
        )
      case .fetchDiaries:
        return .task {
            .diariesResponse(
              await TaskResult {
                try await self.apiClient.requestRaw(.fetchDiaries)
              }
            )
        }
      case .diariesResponse(.success(let result)):
        print(result)
//        state.diarys = result.diarys.toDomain()
      case .diariesResponse(.failure(let error)):
        print(error)
      default:
        break
      }
      return .none
    }
  }

  private func loadUserData() async throws -> (diariesResponse: NetworkStatusResponse, profileResponse: FetchProfileResponse) {
    async let diariesResponse = self.apiClient.requestRaw(.fetchDiaries)
    async let profileResponse = self.apiClient.request(.fetchProfile) as FetchProfileResponse

    return try await (diariesResponse, profileResponse)
  }
}

