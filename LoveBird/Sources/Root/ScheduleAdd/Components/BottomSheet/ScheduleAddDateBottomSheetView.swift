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
      BottomSheetView(
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

struct ScheduleAddDateBottomSheetView_Previews: PreviewProvider {
  static var previews: some View {
    ScheduleAddDateBottomSheetView(
      store: .init(
        initialState: ScheduleAddState(schedule: .dummy),
        reducer: ScheduleAddCore()
      )
    )
  }
}
