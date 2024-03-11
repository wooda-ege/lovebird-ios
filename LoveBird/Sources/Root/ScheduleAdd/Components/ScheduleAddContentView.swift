//
//  ScheduleAddContentView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/06/30.
//

import ComposableArchitecture
import SwiftUI

struct ScheduleAddContentView: View {
  let store: StoreOf<ScheduleAddCore>
  
  var body: some View {
    ScrollView {
      VStack(spacing: 8) {
        ScheduleAddTitleView(store: self.store)
        ScheduleAddColorView(store: self.store)
        ScheduleAddStartDateView(store: self.store)
        ScheduleAddEndDateView(store: self.store)
        ScheduleAddTimeView(store: self.store)
        // TODO: FCM 기능 추가 후에 넣을 것
//        ScheduleAddAlarmView(store: self.store)
        ScheduleAddMemoView(store: self.store)
      }
      .padding(.horizontal, 16)
    }
    .frame(maxHeight: .infinity)
  }
}

#Preview {
  ScheduleAddContentView(
    store: .init(
      initialState: ScheduleAddState(schedule: .dummy),
      reducer: { ScheduleAddCore() }
    )
  )
}
