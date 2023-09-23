//
//  AddScheduleAlarmBottomSheet.swift
//  LoveBird
//
//  Created by 황득연 on 2023/07/02.
//

import ComposableArchitecture
import SwiftUI

struct ScheduleAddAlarmBottomSheetView: View {
  let store: StoreOf<ScheduleAddCore>

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      BottomSheetView(
        isOpen: viewStore.binding(
          get: \.showAlarmBottomSheet, 
          send: .hideAlarmBottomSheet
        )
      ) {
        VStack {
          ForEach(ScheduleAlarm.allCases.filter { $0 != .none }, id: \.self) { alarm in
            VStack(spacing: 0) {
              HStack(alignment: .center, spacing: 18) {
                Text(alarm.description)
                  .font(.pretendard(size: 16))
                  .foregroundColor(.black)
                  .frame(maxWidth: .infinity, alignment: .leading)

                if viewStore.alarm == alarm {
                  Image(R.image.ic_check_circle)
                    .resizable()
                    .frame(width: 24, height: 24)
                }
              }
              .padding(.vertical, 18)
              .padding(.horizontal, 16)

              Rectangle()
                .fill(Color(R.color.gray03))
                .frame(height: 1)
            }
            .frame(maxWidth: .infinity)
            .background(.white)
            .onTapGesture {
              viewStore.send(.alarmSelected(alarm))
            }
          }
        }
      }
    }
  }
}

struct ScheduleAddAlarmBottomSheetView_Previews: PreviewProvider {
  static var previews: some View {
    ScheduleAddAlarmBottomSheetView(
      store: .init(
        initialState: ScheduleAddState(schedule: .dummy),
        reducer: ScheduleAddCore()
      )
    )
  }
}
