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
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      NavigationView {
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
      .navigationViewStyle(StackNavigationViewStyle())
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
