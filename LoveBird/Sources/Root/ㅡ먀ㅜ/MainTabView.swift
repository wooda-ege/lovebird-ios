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
              Image(R.image.ic_timeline)
              
              Text(R.string.localizable.main_tab_home)
                .font(.pretendard(size: 12))
            }
            .tag(MainTabCore.Tab.home)
          
          CalendarView(store: self.store.scope(state: \.calander!, action: MainTabCore.Action.calander))
            .tabItem {
              Image(R.image.ic_calendar)
              
              Text(R.string.localizable.main_tab_calendar)
                .font(.pretendard(size: 12))
            }
            .tag(MainTabCore.Tab.canlander)
          
          DiaryView(store: self.store.scope(state: \.diary!, action: MainTabCore.Action.diary))
            .tabItem {
              Image(R.image.ic_note)
              
              Text(R.string.localizable.main_tab_note)
                .font(.pretendard(size: 12))
            }
            .tag(MainTabCore.Tab.diary)
          
          MyPageView(store: self.store.scope(state: \.myPage!, action: MainTabCore.Action.myPage))
            .tabItem {
              Image(R.image.ic_person)
              
              Text(R.string.localizable.main_tab_my_page)
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

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
      MainTabView(
        store: Store(
          initialState: MainTabState(),
          reducer: MainTabCore()
        )
      )
    }
}
