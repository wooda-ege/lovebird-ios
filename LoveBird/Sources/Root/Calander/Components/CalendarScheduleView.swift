//
//  CalendarScheduleView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/06/30.
//

import ComposableArchitecture
import SwiftUI

struct CalendarScheduleView: View {

  let store: StoreOf<CalendarCore>

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      HStack {
        Text("\(viewStore.currentDate.month)월 \(viewStore.currentDate.day)일")
          .font(.pretendard(size: 14, weight: .bold))
          .foregroundColor(.black)

        Spacer()
      }
      .padding(.top, 24)

      Spacer(minLength: 12)

      VStack(alignment: .center, spacing: 8) {
        if viewStore.schedulesOfDay.isEmpty {
          Text("일정 없음")
            .font(.pretendard(size: 16))
            .multilineTextAlignment(.center)
            .foregroundColor(Color(asset: LoveBirdAsset.gray05))
            .frame(maxWidth: .infinity)
            .frame(height: 40, alignment: .center)
        } else {
          ForEach(viewStore.schedulesOfDay, id: \.id) { schedule in
            NavigationLinkStore(
              self.store.scope(state: \.$scheduleDetail, action: CalendarAction.scheduleDetail)
            ) {
              viewStore.send(.scheduleTapped(schedule))
            } destination: { store in
              ScheduleDetailView(store: store)
            } label: {
              HStack(alignment: .center, spacing: 4) {
                Rectangle()
                  .fill(schedule.color.color)
                  .frame(width: 2)
                  .frame(maxHeight: .infinity)
                  .cornerRadius(1)

                Text(schedule.title)
                  .font(.pretendard(size: 14))
                  .foregroundColor(.black)
                  .padding(.horizontal, 16)
                  .padding(.vertical, 12)
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .background(.white)
                  .cornerRadius(8)
              }
            }
          }
          // NavigationLink presenting a value must appear inside a NavigationContent-based NavigationView. Link will be disabled.
          // VStack 내에 NavigationLinkStore가 count가 2개면 위 오류가 존재해서 스스로 Navigation Cancel이 되어버림.
          if viewStore.schedulesOfDay.count == 2 {
            NavigationLinkStore(
              self.store.scope(state: \.$scheduleDetail, action: CalendarAction.scheduleDetail)
            ) {
              viewStore.send(.scheduleTapped(.dummy))
            } destination: { store in
              ScheduleDetailView(store: store)
            } label: {
              EmptyView()
            }
          }
        }
      }
      .padding([.top, .horizontal], 16)
      .padding(.bottom, viewStore.schedulesOfDay.count == 2 ? 8 : 16)
      .background(Color(asset: LoveBirdAsset.gray03))
      .cornerRadius(12)
    }
  }
}

struct CalendarScheduleView_Previews: PreviewProvider {
  static var previews: some View {
    CalendarScheduleView(
      store: Store(
        initialState: CalendarState(),
        reducer: CalendarCore()
      )
    )
  }
}
