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
        WithViewStore(self.store) { viewStore in
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
                            Text("홈")
                                .font(.pretendard(size: 12))
                        }
                        .tag(MainTabCore.Tab.home)
                    CalanderView(store: self.store.scope(state: \.calander!, action: MainTabCore.Action.calander))
                        .tabItem {
                            Image(R.image.ic_calendar)
                            Text("캘린더")
                                .font(.pretendard(size: 12))
                        }
                        .tag(MainTabCore.Tab.canlander)
                    DiaryView(store: self.store.scope(state: \.diary!, action: MainTabCore.Action.diary))
                        .tabItem {
                            Image(R.image.ic_note)
                            Text("일기 작성")
                                .font(.pretendard(size: 12))
                        }
                        .tag(MainTabCore.Tab.diary)
                    MyPageView(store: self.store.scope(state: \.myPage!, action: MainTabCore.Action.myPage))
                        .tabItem {
                            Image(R.image.ic_person)
                            Text("마이페이지")
                                .font(.pretendard(size: 12))
                        }
                        .tag(MainTabCore.Tab.myPage)
                }
                .onAppear {
                    let appearance = UITabBarAppearance()
                    appearance.backgroundColor = .white
                    appearance.shadowImage = UIImage.showdowImage
                    UITabBar.appearance().scrollEdgeAppearance = appearance
                }
            }
        }
    }
}


// MARK: - Preview
//
//struct MainTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainTabView()
//    }
//}
