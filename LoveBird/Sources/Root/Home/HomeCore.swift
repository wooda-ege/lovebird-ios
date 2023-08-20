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

typealias HomeState = HomeCore.State
typealias HomeAction = HomeCore.Action

struct HomeCore: ReducerProtocol {

  // MARK: - State

  struct State: Equatable {
    @PresentationState var diaryDetail: DiaryDetailState?

    var diaries: [Diary] = []
    var offsetY: CGFloat = 0.0
    var contentHeight: CGFloat = 0.0
    var isScrolledToBottom: Bool = false
  }

  // MARK: - Action
  
  enum Action: Equatable {
    case diaryDetail(PresentationAction<DiaryDetailAction>)
    case viewAppear
    case dataLoaded([Diary])
    case diaryTitleTapped(Diary)
    case diaryTapped(Diary)
    case todoDiaryTapped
    case offsetYChanged(CGFloat)
    case contentHeightChanged(CGFloat)
    case scrolledToBottom
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

            self.userData.store(key: .user, value: profileLoaded)
            
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
        guard let user = self.userData.get(key: .user, type: Profile.self) else { return .none}
        var nickname: String?
        if let partnerNickname = user.partnerNickname {
          nickname = user.memberId == diary.memberId ? user.nickname : partnerNickname
        } else {
          nickname = nil
        }
        state.diaryDetail = DiaryDetailState(diary: diary, nickname: nickname)
        return .none

      case .offsetYChanged(let y):
        state.offsetY = y
        return .none

      case .contentHeightChanged(let height):
        state.contentHeight = height
        return .none

      case .scrolledToBottom:
        state.isScrolledToBottom = true
        return .none

        // MARK: - DiaryDetail

      case .diaryDetail(.presented(.backTapped)), .diaryDetail(.presented(.deleteDiaryResponse(.success))):
        state.diaryDetail = nil
        return .none

      default:
        return .none
      }
    }
    .ifLet(\.$diaryDetail, action: /Action.diaryDetail) {
      DiaryDetailCore()
    }
  }

  private func diariesForDomain(diaries: [Diary], profile: Profile) -> [Diary] {

    var isTodayDiaryAppended = false

    // D + 1
    var diariesForDomain: [Diary] = [Diary.initialDiary(with: profile.firstDate)]
    diaries.enumerated().forEach { idx, diary in
      var diaryUpdated = diary

      // 연속된 두 날짜가 오는 경우, 뒤의 Diary의 타임라인의 Date를 표기하기 않는다.
      if idx != 0, diaries[idx - 1].memoryDate.toDate() == diaries[idx].memoryDate.toDate() {
        diaryUpdated.isTimelineDateShown = false
      }

      if diary.memoryDate.toDate().isToday {
        isTodayDiaryAppended = true

        // 이틀 연속 당일이라면 전에 기록된 Diary의 TimeState는 previous이다.
        if diaries.count > idx + 1, diaries[idx + 1].memoryDate.toDate().isToday {
          diaryUpdated.timeState = .previous
        } else {
          diaryUpdated.timeState = .current
        }
        diaryUpdated.isFolded = false
        diariesForDomain.append(diaryUpdated)
      } else if diary.memoryDate.toDate().isLater(than: Date()) {
        diaryUpdated.timeState = .following
        diariesForDomain.append(diaryUpdated)
      } else {
        diariesForDomain.append(diaryUpdated)
      }
    }

    // 오늘 일 자
    if !isTodayDiaryAppended {
      diariesForDomain.append(Diary.todoDiary(with: Date().to(dateFormat: Date.Format.YMDDivided)))
    }

    // 다음 기념일
    diariesForDomain.append(Diary.anniversaryDiary(
      with: profile.nextAnniversary.anniversaryDate,
      title: profile.nextAnniversary.kind.description
    ))

    return diariesForDomain
  }
}

