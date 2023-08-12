//
//  ScheduleAddContentView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/06/30.
//

import ComposableArchitecture
import SwiftUI

struct ScheduleAddContentView: View {

  let viewStore: ViewStore<ScheduleAddState, ScheduleAddAction>
  
  var body: some View {
    ScrollView {
      VStack(spacing: 8) {
        ScheduleAddTitleView(viewStore: self.viewStore)
        
        ScheduleAddColorView(viewStore: self.viewStore)

        ScheduleAddStartDateView(viewStore: self.viewStore)

        ScheduleAddEndDateView(viewStore: self.viewStore)

        ScheduleAddTimeView(viewStore: self.viewStore)

        ScheduleAddAlarmView(viewStore: self.viewStore)

        ScheduleAddMemoView(viewStore: self.viewStore)
      }
      .padding(.horizontal, 16)
    }
    .frame(maxHeight: .infinity)
  }
}

//struct AddScheduleContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddScheduleContentView()
//    }
//}
