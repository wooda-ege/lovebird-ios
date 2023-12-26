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

struct HomeCore: Reducer {

  // MARK: - State

  struct State: Equatable {
    var mode: AppConfiguration.Mode = .single
    var profile: Profile?
    var diaries: [HomeDiary] = []
    var lineHeight: CGFloat = 0.0
    var contentHeight: CGFloat = 0.0
    var isScrolledToBottom: Bool = false
  }

  // MARK: - Action
  
  enum Action: Equatable {
    case viewAppear
    case dataLoaded(Profile, [HomeDiary])
    case diaryTitleTapped(HomeDiary)
    case diaryTapped(HomeDiary)
    case todoDiaryTapped
    case offsetYChanged(CGFloat)
    case contentHeightChanged(CGFloat)
    case scrolledToBottom
  }

  @Dependency(\.lovebirdApi) var lovebirdApi
  @Dependency(\.userData) var userData
  @Dependency(\.appConfiguration) var appConfiguration
  @Dependency(\.loadingController) var loadingController

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {

      // MARK: - Life Cycle

      case .viewAppear:
        return .run { send in
          do {
            loadingController.isLoading = true
            let diaries = try await lovebirdApi.fetchDiaries()
            let profile = try await lovebirdApi.fetchProfile()

            userData.store(key: .user, value: profile)

            let homeDiaries = diariesForHome(
              diaries: diaries.map { $0.toHomeDiary(with: profile) },
              profile: profile
            )
            await send(.dataLoaded(profile, homeDiaries))
            loadingController.isLoading = false
          } catch {
            loadingController.isLoading = false
          }
        }

      case let .dataLoaded(profile, diaries):
        state.profile = profile
        state.diaries = diaries
        state.mode = appConfiguration.mode
        return .none

      case let .diaryTitleTapped(diary):
        if let idx = state.diaries.firstIndex(where: { $0.diaryId == diary.diaryId }) {
          state.diaries[idx].isFolded.toggle()
        }
        return .none

      case let .offsetYChanged(y):
        _printChanges()
        state.lineHeight = lineHeight(offsetY: y)
        return .none

      case let .contentHeightChanged(height):
        state.contentHeight = height
        return .none

      case .scrolledToBottom:
        state.isScrolledToBottom = true
        return .none

      default:
        return .none
      }
    }
  }

  private func lineHeight(offsetY: CGFloat) -> CGFloat {
    min(
      UIScreen.heightExceptSafeArea,
      max(0, offsetY - (UIApplication.edgeInsets.top + 44))
    )
  }

  private func diariesForHome(diaries: [HomeDiary], profile: Profile) -> [HomeDiary] {

    var isTodayDiaryAppended = false

    // D + 1
    var diariesForDomain: [HomeDiary] = [HomeDiary.initialDiary(with: profile.firstDate ?? "0000-00-00")]
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
      diariesForDomain.append(HomeDiary.todoDiary(with: Date().to(dateFormat: Date.Format.YMDDivided)))
    }

    // 다음 기념일
    guard let  nextAnniversary = profile.nextAnniversary else {
      return diariesForDomain
    }
    
    diariesForDomain.append(HomeDiary.anniversaryDiary(
      with: nextAnniversary.anniversaryDate,
      title: nextAnniversary.kind.description 
    ))

    return diariesForDomain
  }
}

typealias HomeState = HomeCore.State
typealias HomeAction = HomeCore.Action
