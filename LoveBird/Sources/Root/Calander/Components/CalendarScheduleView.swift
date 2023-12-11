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
            Button { viewStore.send(.scheduleTapped(schedule)) } label: {
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
        }
      }
      .padding([.top, .horizontal], 16)
      .padding(.bottom, viewStore.schedulesOfDay.count == 2 ? 8 : 16)
      .background(Color(asset: LoveBirdAsset.gray03))
      .cornerRadius(12)
    }
  }
}

#Preview {
  CalendarScheduleView(
    store: Store(
      initialState: CalendarState(),
      reducer: { CalendarCore() }
    )
  )
}
