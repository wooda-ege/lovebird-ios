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
    var isLinkSuccessViewShown = false
  }

  // MARK: - Action
  
  enum Action: Equatable {
    case viewAppear
    case dataLoaded(Profile, [HomeDiary])
    case configureUI(Profile, [Diary])
    case diaryTitleTapped(HomeDiary)
    case diaryTapped(HomeDiary)
    case todoDiaryTapped
    case offsetYChanged(CGFloat)
    case contentHeightChanged(CGFloat)
    case scrolledToBottom
    case linkSuccessCloseTapped
    case linkSuccessAddTapped
    case showLinkSuccessView
    case refresh
  }

  @Dependency(\.lovebirdApi) var lovebirdApi
  @Dependency(\.userData) var userData
  @Dependency(\.appConfiguration) var appConfiguration

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {

        // MARK: - Life Cycle
        
      case .viewAppear:
        return .run(isLoading: true) { send in
          do {
            let diaries = try await lovebirdApi.fetchDiaries()
            let profile = try await lovebirdApi.fetchProfile()
            userData.profile.value = profile

            await send(.configureUI(profile, diaries))
            if userData.shouldShowLinkSuccessPopup.value, profile.isLinked {
              await send(.showLinkSuccessView)
            }
          }
        }

      case let .configureUI(profile, diaries):
        let homeDiaries = homeDiaries(
          diaries: diaries.map { $0.toHomeDiary(with: profile) },
          profile: profile
        )
        state.profile = profile
        state.diaries = homeDiaries
        state.mode = userData.mode.value
        return .none

      case let .diaryTitleTapped(diary):
        if let idx = state.diaries.firstIndex(where: { $0.diaryId == diary.diaryId }) {
          state.diaries[idx].isFolded.toggle()
        }
        return .none

      case let .offsetYChanged(y):
        state.lineHeight = lineHeight(offsetY: y)
        return .none

      case let .contentHeightChanged(height):
        state.contentHeight = height
        return .none

      case .scrolledToBottom:
        state.isScrolledToBottom = true
        return .none

      case .linkSuccessCloseTapped:
        state.isLinkSuccessViewShown = false
        return .none

      case .linkSuccessAddTapped:
        return .merge([.send(.todoDiaryTapped), .send(.linkSuccessCloseTapped)])

      case .showLinkSuccessView:
        state.isLinkSuccessViewShown = true
        userData.shouldShowLinkSuccessPopup.value = false
        return .none

      case .refresh:
        return .run(isLoading: true) { [profile = state.profile] send in
          do {
            guard let profile else { return }
            let diaries = try await lovebirdApi.fetchDiaries()
            await send(.configureUI(profile, diaries))
          }
        }

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

  private func homeDiaries(diaries: [HomeDiary], profile: Profile) -> [HomeDiary] {

    var isFirstDateAppended = false
    var shouldNeedTodoDiary = true
    var homeDiaries = [HomeDiary]()

    // D+1
    if let firstDateString = profile.firstDate {
      homeDiaries.append(HomeDiary.initialDiary(with: firstDateString))
    }

    // 다음 기념일
    if let nextAnniversary = profile.nextAnniversary {
      let anniversaryDiary = HomeDiary.anniversaryDiary(
        with: nextAnniversary.anniversaryDate,
        title: nextAnniversary.name
      )
      homeDiaries.append(anniversaryDiary)
    }

    diaries.enumerated().forEach { idx, diary in
      var diaryUpdated = diary

      // 연속된 두 날짜가 오는 경우, 뒤의 Diary의 타임라인의 Date를 표기하기 않는다.
      if idx != 0, diaries[idx - 1].memoryDate.toDate() == diaries[idx].memoryDate.toDate() {
        diaryUpdated.isTimelineDateShown = false
      }

      if diary.memoryDate.toDate().isToday {
        shouldNeedTodoDiary = false

        // 이틀 연속 당일이라면 전에 기록된 Diary의 TimeState는 previous이다.
        if diaries.count > idx + 1, diaries[idx + 1].memoryDate.toDate().isToday {
          diaryUpdated.timeState = .previous
        } else {
          diaryUpdated.timeState = .current
        }
        diaryUpdated.isFolded = false
      } else if diary.memoryDate.toDate().isLater(than: Date()) {
        diaryUpdated.timeState = .following
      }

      homeDiaries.append(diaryUpdated)
    }

    // '오늘 데이트 기록하기'
    if shouldNeedTodoDiary {
      let todoDiary = HomeDiary.todoDiary(with: Date().to(format: .YMDDivided))
      homeDiaries.append(todoDiary)
    }

    return homeDiaries.sorted { $0.memoryDate < $1.memoryDate }
  }
}

typealias HomeState = HomeCore.State
typealias HomeAction = HomeCore.Action
