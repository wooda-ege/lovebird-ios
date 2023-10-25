//
//  ScheduleAddDateBottomSheetView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/07/01.
//

import ComposableArchitecture
import SwiftUI

struct ScheduleAddDateBottomSheetView: View {
  let store: StoreOf<ScheduleAddCore>
  
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      CommonBottomSheetView(
        isOpen: viewStore.binding(
          get: \.showDateBottomSheet,
          send: .hideDateBottomSheet
        )
      ) {
        ScheduleAddDatePickerView(viewStore: viewStore)

        CommonBottomSheetButtonView(
          initialAction: { viewStore.send(.dateInitialied) },
          confirmAction: { viewStore.send(.hideDateBottomSheet) }
        )
      }
    }
  }
}

#Preview {
	ScheduleAddDateBottomSheetView(
		store: .init(
			initialState: ScheduleAddState(schedule: .dummy),
			reducer: { ScheduleAddCore() }
		)
	)
}
