//
//  ScheduleAddView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/06/30.
//

import ComposableArchitecture
import SwiftUI

struct ScheduleAddView: View {
  let store: StoreOf<ScheduleAddCore>

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      ZStack {
        VStack {
          CommonToolBar(
            title: String(resource: R.string.localizable.add_schedule_title),
            backButtonTapped: { viewStore.send(.backButtonTapped) }
          ) {
            NavigationLinkStore(
              self.store.scope(state: \.$scheduleDetail, action: ScheduleAddAction.scheduleDetail)
            ) {
              viewStore.send(.confirmTapped)
            } destination: { store in
              ScheduleDetailView(store: store)
            } label: {
              Text(R.string.localizable.common_complete)
                .foregroundColor(viewStore.title.isEmpty ? Color(R.color.green234) : Color(R.color.primary))
                .font(.pretendard(size: 16, weight: .bold))
            }
          }

          ScheduleAddContentView(store: self.store)
        }
        .navigationBarBackButtonHidden(true)

        // MARK: BottomSheet

        ScheduleAddColorBottomSheetView(store: self.store)
        ScheduleAddDateBottomSheetView(store: self.store)
        ScheduleAddTimeBottomSheetView(store: self.store)
        ScheduleAddAlarmBottomSheetView(store: self.store)
      }
    }
  }
}

struct ScheduleAddView_Previews: PreviewProvider {
  static var previews: some View {
    ScheduleAddView(
      store: .init(
        initialState: ScheduleAddState(schedule: .dummy),
        reducer: ScheduleAddCore()
      )
    )
  }
}
