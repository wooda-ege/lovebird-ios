//
//  CalendarView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/28.
//

import ComposableArchitecture
import SwiftUI

struct CalendarView: View {
  let store: StoreOf<CalendarCore>

  var body: some View {
    WithViewStore(self.store) { viewStore in
      VStack(spacing: 0) {
        CalendarTabView(store: self.store)

        CalendarContentView(viewStore: viewStore)
      }
//      NavigationLink(
//        destination: IfLetStore(self.store.scope(state: \.addSchedule, action: CalendarAction.addSchedule)) {
//
//        },
//        isActive: viewStore.binding(
//          get: \.isGameActive,
//          send: { .addSchedule }
//        ),
//        label: EmptyView()
//      )
//      .disabled(viewStore.isLetsPlayButtonDisabled)
//      .navigationTitle("New Game")
//      .navigationBarItems(trailing: Button("Logout") { viewStore.send(.logoutButtonTapped) })
    }
  }
}

//struct CalanderView_Previews: PreviewProvider {
//    static var previews: some View {
//        CalanderView()
//    }
//}
