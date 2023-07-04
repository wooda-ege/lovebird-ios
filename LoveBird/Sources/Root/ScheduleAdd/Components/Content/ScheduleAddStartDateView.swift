//
//  ScheduleAddStartDateView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/07/01.
//

import ComposableArchitecture
import SwiftUI

struct ScheduleAddStartDateView: View {
  
  let viewStore: ViewStore<ScheduleAddState, ScheduleAddAction>
  
  var body: some View {
    ScheduleAddFocusedView(isFocused: self.viewStore.focusedType == .startDate) {
      Image(R.image.ic_calendar)
      Text(self.viewStore.startDate.toYMDFormat)
        .font(.pretendard(size: 18))
        .foregroundColor(.black)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    .onTapGesture {
      self.viewStore.send(.contentTapped(.startDate))
    }
  }
}

//struct AddScheduleStartDateView_Previews: PreviewProvider {
//  static var previews: some View {
//    AddScheduleStartDateView()
//  }
//}
