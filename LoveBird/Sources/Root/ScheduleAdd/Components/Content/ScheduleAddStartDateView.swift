//
//  ScheduleAddStartDateView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/07/01.
//

import ComposableArchitecture
import SwiftUI

struct ScheduleAddStartDateView: View {
  let store: StoreOf<ScheduleAddCore>

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      CommonFocusedView(isFocused: viewStore.focusedType == .startDate) {
        Image(asset: LoveBirdAsset.icCalendar)

        Text(viewStore.startDate.to(format: .YMD))
          .font(.pretendard(size: 18))
          .foregroundColor(.black)
          .frame(maxWidth: .infinity, alignment: .leading)
      }
      .onTapGesture {
        viewStore.send(.contentTapped(.startDate))
      }
    }
  }
}

#Preview {
  ScheduleAddStartDateView(
    store: .init(
      initialState: ScheduleAddState(schedule: .dummy),
      reducer: { ScheduleAddCore() }
    )
  )
}
