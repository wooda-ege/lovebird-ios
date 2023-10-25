//
//  AddScheduleTimeBottomSheetView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/07/02.
//

import ComposableArchitecture
import SwiftUI

struct ScheduleAddTimeBottomSheetView: View {
  let store: StoreOf<ScheduleAddCore>

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      CommonBottomSheetView(
        isOpen: viewStore.binding(
          get: \.showTimeBottomSheet,
          send: .hideTimeBottomSheet
        )
      ) {
        ScheduleAddTimePickerView(viewStore: viewStore)

        CommonBottomSheetButtonView(
          initialAction: { viewStore.send(.timeInitialied) },
          confirmAction: { viewStore.send(.hideTimeBottomSheet) }
        )
      }
    }
  }
}

#Preview {
	ScheduleAddTimeBottomSheetView(
		store: .init(
			initialState: ScheduleAddState(schedule: .dummy),
			reducer: { ScheduleAddCore() }
		)
	)
}
