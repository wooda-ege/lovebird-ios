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
    WithViewStore(self.store) { viewStore in
      HStack(alignment: .center) {
        HStack(spacing: 0) {
          Text(String(viewStore.currentDate.year) + "." + String(viewStore.currentDate.month))
            .font(.pretendard(size: 22, weight: .bold))
            .foregroundColor(.black)

          Image(R.image.ic_arrow_drop_down)
            .frame(width: 24, height: 24)
        }

        Spacer()

        HStack(spacing: 16) {
          // TODO: 차후 업데이트에 넣을 예정
          //            Button { viewStore.send(.searchTapped) } label: {
          //              Image(R.image.ic_filter_list)
          //            }
          //            Button { viewStore.send(.searchTapped) } label: {
          //              Image(R.image.ic_search)
          //            }
          NavigationLink(
            destination: IfLetStore(
              self.store.scope(state: \.addSchedule, action: CalendarAction.scheduleAdd)
            ) {
              ScheduleAddView(store: $0)
            },
            isActive: viewStore.binding(get: \.isScheduleAddActive, send: { $0 ? .plusTapped : .popScheduleAdd } )
          ) {
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
