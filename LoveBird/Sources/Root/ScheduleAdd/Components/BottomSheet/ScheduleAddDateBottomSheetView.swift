//
//  ScheduleAddDateBottomSheetView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/07/01.
//

import ComposableArchitecture
import SwiftUI

struct ScheduleAddDateBottomSheetView: View {

  let viewStore: ViewStore<ScheduleAddState, ScheduleAddAction>
  
  var body: some View {
    CommonBottomSheetView(isOpen: self.viewStore.binding(get: \.showDateBottomSheet, send: .hideDateBottomSheet)) {
      ScheduleAddDatePickerView(viewStore: self.viewStore)

      CommonBottomSheetButtonView(
        initialAction: { self.viewStore.send(.dateInitialied) },
        confirmAction: { self.viewStore.send(.hideDateBottomSheet) }
      )
    }
  }
}

//struct AddScheduleDateBottomSheetView_Previews: PreviewProvider {
//  static var previews: some View {
//    AddScheduleDateBottomSheetView()
//  }
//}
