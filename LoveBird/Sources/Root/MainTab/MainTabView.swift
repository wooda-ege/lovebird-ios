//
//  MainTabView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/25.
//

import UIKit
import SwiftUI
import ComposableArchitecture

struct MainTabView: View {
  let store: StoreOf<MainTabCore>

  var body: some View {
    NavigationStackStore(store.scope(state: \.path, action: { .path($0) })) {
      WithViewStore(self.store, observe: { $0 }) { viewStore in
        TabView(
          selection: viewStore.binding(
            get: \.selectedTab,
            send: MainTabCore.Action.tabSelected
          )
        ) {
          HomeView(store: self.store.scope(state: \.home!, action: MainTabCore.Action.home))
            .tabItem {
              Image(asset: LoveBirdAsset.icTimeline)

              Text(LoveBirdStrings.mainTabHome)
                .font(.pretendard(size: 12))
            }
            .tag(MainTabCore.Tab.home)

          CalendarView(store: self.store.scope(state: \.calander!, action: MainTabCore.Action.calander))
            .tabItem {
              Image(asset: LoveBirdAsset.icCalendar)

              Text(LoveBirdStrings.mainTabCalendar)
                .font(.pretendard(size: 12))
            }
            .tag(MainTabCore.Tab.canlander)

          DiaryView(store: self.store.scope(state: \.diary!, action: MainTabCore.Action.diary))
            .tabItem {
              Image(asset: LoveBirdAsset.icNote)

              Text(LoveBirdStrings.mainTabNote)
                .font(.pretendard(size: 12))
            }
            .tag(MainTabCore.Tab.diary)

          MyPageView(store: self.store.scope(state: \.myPage!, action: MainTabCore.Action.myPage))
            .tabItem {
              Image(asset: LoveBirdAsset.icPerson)

              Text(LoveBirdStrings.mainTabMyPage)
                .font(.pretendard(size: 12))
            }
            .tag(MainTabCore.Tab.myPage)
        }
        .onAppear {
          self.setTabBarAppearance()
        }
      }
    } destination: { path in
      switch path {
      case .diaryDetail:
        CaseLet(
          /MainTabPathState.diaryDetail,
           action: MainTabPathAction.diaryDetail,
           then: DiaryDetailView.init
        )
      case .scheduleDetail:
        CaseLet(
          /MainTabPathState.scheduleDetail,
           action: MainTabPathAction.scheduleDetail,
           then: ScheduleDetailView.init
        )
      case .scheduleAdd:
        CaseLet(
          /MainTabPathState.scheduleAdd,
           action: MainTabPathAction.scheduleAdd,
           then: ScheduleAddView.init
        )
      case .searchPlace:
        CaseLet(
          /MainTabPathState.searchPlace,
           action: MainTabPathAction.searchPlace) { store in
             SearchPlaceView(store: store)
           }
      case .myPageProfileEdit:
        CaseLet(
          /MainTabPathState.myPageProfileEdit,
           action: MainTabPathAction.myPageProfileEdit){ store in
             MyPageProfileEditView(store: store)
           }
      case .diary:
        CaseLet(
          /MainTabPathState.diary,
           action: MainTabPathAction.diary){ store in
             DiaryView(store: store)
           }
      }
    }
  }

  private func setTabBarAppearance() {
    let appearance = UITabBarAppearance()
    appearance.backgroundColor = .white
    appearance.shadowImage = UIImage.shadowImage
    UITabBar.appearance().scrollEdgeAppearance = appearance
  }
}

// MARK: - Preview

#Preview {
  MainTabView(
    store: Store(
      initialState: MainTabState(),
      reducer: { MainTabCore() }
    )
  )
}
