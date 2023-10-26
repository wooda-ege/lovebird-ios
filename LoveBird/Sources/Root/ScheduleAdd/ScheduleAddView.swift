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
            title: LoveBirdStrings.addScheduleTitle,
            backButtonTapped: { viewStore.send(.backButtonTapped) }
          ) {
            NavigationLinkStore(
              self.store.scope(state: \.$scheduleDetail, action: ScheduleAddAction.scheduleDetail)
            ) {
              viewStore.send(.confirmTapped)
            } destination: { store in
              ScheduleDetailView(store: store)
            } label: {
              Text(LoveBirdStrings.commonComplete)
                .foregroundColor(viewStore.title.isEmpty ? Color(asset: LoveBirdAsset.green234) : Color(asset: LoveBirdAsset.primary))
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

#Preview {
  ScheduleAddView(
    store: .init(
      initialState: ScheduleAddState(schedule: .dummy),
      reducer: { ScheduleAddCore() }
    )
  )
}
