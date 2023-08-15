//
//  HomeCore.swift
//  wooda
//
//  Created by 황득연 on 2023/05/09.
//

import Foundation
import ComposableArchitecture
import SwiftUI
import Combine

struct HomeCore: ReducerProtocol {

  // MARK: - State

  struct State: Equatable {
    var diaries: [Diary] = []
    var offsetY: CGFloat = 0.0
  }

  // MARK: - Action
  
  enum Action: Equatable {
    case viewAppear
    case dataLoaded([Diary])
    case diaryTitleTapped(Diary)
    case diaryTapped(Diary)
    case todoDiaryTapped
    case offsetYChanged(CGFloat)
  }

  @Dependency(\.apiClient) var apiClient
  @Dependency(\.userData) var userData

  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {

      // MARK: - Life Cycle

      case .viewAppear:
        return .run { send in
          do {
            let diariesLoaded = try await self.apiClient.request(.fetchDiaries) as Diaries
            let profileLoaded = try await self.apiClient.request(.fetchProfile) as Profile
            let diaries = self.diariesForDomain(
              diaries: diariesLoaded.diaries.map { $0.toDiary() },
              profile: profileLoaded
            )
            await send(.dataLoaded(diaries))
          }
        }

      case .dataLoaded(let diaries):
        state.diaries = diaries
        return .none

      case .diaryTitleTapped(let diary):
        if let idx = state.diaries.firstIndex(where: { $0.diaryId == diary.diaryId }) {
          state.diaries[idx].isFolded.toggle()
        }
        return .none

      case .diaryTapped(let diary):
        // TODO: 다이어리 상세페이지로 이동
        return .none

      case .offsetYChanged(let y):
        state.offsetY = y
        return .none

      default:
        return .none
      }
    }
  }

  private func diariesForDomain(diaries: [Diary], profile: Profile) -> [Diary] {
    self.userData.store(key: .user, value: profile)

    var diariesForDomain: [Diary] = [Diary.initialDiary(with: profile.firstDate)]
    diariesForDomain.append(contentsOf: diaries)

    if self.shouldAppendTodoDiary(with: diaries) {
      diariesForDomain.append(Diary.todoDiary(with: Date().to(dateFormat: Date.Format.YMDDivided)))
    }

    diariesForDomain.append(Diary.anniversaryDiary(
      with: profile.nextAnniversary.anniversaryDate,
      title: profile.nextAnniversary.kind.description
    ))

    return diariesForDomain
  }

  private func shouldAppendTodoDiary(with diaries: [Diary]) -> Bool {
    guard let diary = diaries.last else { return true }
    return diary.memoryDate != Date().to(dateFormat: Date.Format.YMD)
  }
}

