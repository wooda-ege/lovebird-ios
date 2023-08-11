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
    var diaries: [Diary] = []
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
    case dataLoaded([Diary])
    case loadData
  }

  @Dependency(\.apiClient) var apiClient

  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .diaryTitleTapped(let diary):
        if let idx = state.diaries.firstIndex(where: { $0.id == diary.id }) {
          state.diaries[idx].isFolded.toggle()
        }
      case .offsetYChanged(let y):
        state.offsetY = y

        // MARK: - Network

      case .loadData:
        return .run { send in
          do {
            let diariesLoaded = try await self.apiClient.request(.fetchDiaries) as Diaries
            let profileLoaded = try await self.apiClient.request(.fetchProfile) as Profile
            
            var diaries: [Diary] = [Diary.initialDiary(with: profileLoaded.firstDate)]
            diaries.append(contentsOf: diariesLoaded.diaries)

            if self.shouldAppendTodoDiary(with: diariesLoaded.diaries) {
              diaries.append(Diary.todoDiary(with: Date().to(dateFormat: Date.Format.YMDDivided)))
            }

            diaries.append(Diary.anniversaryDiary(
              with: profileLoaded.nextAnniversary.anniversaryDate,
              title: profileLoaded.nextAnniversary.kind.description
            ))
            await send(.dataLoaded(diaries))
          } catch {
//            fatalError("\(error)")
          }
        }
      case .dataLoaded(let diaries):
        state.diaries = diaries
      default:
        break
      }
      return .none
    }
  }

  private func shouldAppendTodoDiary(with diaries: [Diary]) -> Bool {
    guard let diary = diaries.last else { return true }
    return diary.memoryDate != Date().to(dateFormat: Date.Format.YMD)
  }
}

