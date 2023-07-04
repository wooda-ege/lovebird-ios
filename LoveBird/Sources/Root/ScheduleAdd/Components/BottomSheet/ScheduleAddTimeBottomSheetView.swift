//
//  AddScheduleTimeBottomSheetView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/07/02.
//

import ComposableArchitecture
import SwiftUI

struct ScheduleAddTimeBottomSheetView: View {

  let viewStore: ViewStore<ScheduleAddState, ScheduleAddAction>

  var body: some View {
    BottomSheetView(isOpen: self.viewStore.binding(get: \.showTimeBottomSheet, send: .hideTimeBottomSheet)) {
      ScheduleAddTimePickerView(viewStore: self.viewStore)

      CommonBottomSheetButtonView(
        initialAction: { self.viewStore.send(.timeInitialied) },
        confirmAction: { self.viewStore.send(.hideTimeBottomSheet) }
      )
    }
  }
}

//struct AddScheduleTimeBottomSheetView_Previews: PreviewProvider {
//  static var previews: some View {
//    AddScheduleTimeBottomSheetView()
//  }
//}
