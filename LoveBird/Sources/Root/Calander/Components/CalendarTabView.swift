//
//  CalendarTabView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/06/30.
//

import ComposableArchitecture
import SwiftUI

struct CalendarTabView: View {

  let store: StoreOf<CalendarCore>

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      HStack(alignment: .center) {
        HStack(spacing: 0) {
          Text("\(viewStore.currentDate.year).\(viewStore.currentDate.month)")
            .font(.pretendard(size: 22, weight: .bold))
            .foregroundColor(.black)

          Image(R.image.ic_arrow_drop_down)
            .frame(width: 24, height: 24)
        }
        .onTapGesture {
          viewStore.send(.toggleTapped)
        }

        Spacer()

        HStack(spacing: 16) {
          NavigationLinkStore(
            self.store.scope(state: \.$scheduleAdd, action: CalendarAction.scheduleAdd)
          ) {
            viewStore.send(.plusTapped)
          } destination: { store in
            ScheduleAddView(store: store)
          } label: {
            Image(R.image.ic_plus)
          }
        }
      }
      .frame(height: 44)
      .padding(.horizontal, 16)
    }
  }
}

//struct CalendarTabView_Previews: PreviewProvider {
//  static var previews: some View {
//    CalendarTabView()
//  }
//}
