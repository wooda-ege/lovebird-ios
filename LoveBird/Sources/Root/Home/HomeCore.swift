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
    case diaryTitleTapped(HomeDiary)
    case diaryTapped(HomeDiary)
    case todoDiaryTapped
    case offsetYChanged(CGFloat)
    case contentHeightChanged(CGFloat)
    case scrolledToBottom
    case linkSuccessCloseTapped
    case showLinkSuccessView
  }

  @Dependency(\.lovebirdApi) var lovebirdApi
  @Dependency(\.userData) var userData
  @Dependency(\.appConfiguration) var appConfiguration

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {

        // MARK: - Life Cycle
        
      case .viewAppear:
        return .runWithLoading { send in
          do {
            let diaries = try await lovebirdApi.fetchDiaries()
            let profile = try await lovebirdApi.fetchProfile()

            userData.remove(key: .user)
            userData.store(key: .user, value: profile)

            let homeDiaries = diariesForHome(
              diaries: diaries.map { $0.toHomeDiary(with: profile) },
              profile: profile
            )
            await send(.dataLoaded(profile, homeDiaries))
            
            if let shouldShow = userData.get(key: .shouldShowLinkSuccessPopup, type: Bool.self),
               shouldShow {
              await send(.showLinkSuccessView)
            }
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
        userData.store(key: .shouldShowLinkSuccessPopup, value: false)
        return .none
        
      case .showLinkSuccessView:
        state.isLinkSuccessViewShown = true
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

    var isFirstDateAppended = false
    var isTodayDiaryAppended = false
    var diariesForHome = [HomeDiary]()

    diaries.enumerated().forEach { idx, diary in
      var diaryUpdated = diary

      // 연속된 두 날짜가 오는 경우, 뒤의 Diary의 타임라인의 Date를 표기하기 않는다.
      if idx != 0, diaries[idx - 1].memoryDate.toDate() == diaries[idx].memoryDate.toDate() {
        diaryUpdated.isTimelineDateShown = false
      }

      // D+1
      if let firstDateString = profile.firstDate,
         let firstDate = Date(from: firstDateString),
         isFirstDateAppended.not,
         firstDate <= diaries[idx].memoryDate.toDate() {
        isFirstDateAppended = true
        diariesForHome.append(HomeDiary.initialDiary(with: firstDateString))
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
        diariesForHome.append(diaryUpdated)
      } else if diary.memoryDate.toDate().isLater(than: Date()) {
        diaryUpdated.timeState = .following
        diariesForHome.append(diaryUpdated)
      } else {
        diariesForHome.append(diaryUpdated)
      }
    }

    // 오늘 일 자
    if !isTodayDiaryAppended {
      diariesForHome.append(HomeDiary.todoDiary(with: Date().to(format: .YMDDivided)))
    }

    // 다음 기념일
    guard let  nextAnniversary = profile.nextAnniversary else {
      return diariesForHome
    }
    
    diariesForHome.append(HomeDiary.anniversaryDiary(
      with: nextAnniversary.anniversaryDate,
      title: nextAnniversary.kind.description 
    ))

    return diariesForHome
  }
}

typealias HomeState = HomeCore.State
typealias HomeAction = HomeCore.Action
