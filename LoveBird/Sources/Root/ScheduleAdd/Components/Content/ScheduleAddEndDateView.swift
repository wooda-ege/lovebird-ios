//
//  ScheduleAddEndDateView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/07/01.
//

import ComposableArchitecture
import SwiftUI

struct ScheduleAddEndDateView: View {
  let store: StoreOf<ScheduleAddCore>

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      CommonFocusedView(isFocused: viewStore.focusedType == .endDate) {
        VStack {
          HStack {
            Text(LoveBirdStrings.addScheduleEndDate)
              .font(.pretendard(size: 16))
              .foregroundColor(viewStore.focusedType == .endDate ? .black : Color(asset: LoveBirdAsset.gray06))

            Toggle(
              isOn: viewStore.binding(
                get: \.isEndDateActive,
                send: ScheduleAddAction.endDateToggleTapped
              )
            ) { EmptyView() }
              .toggleStyle(
                SwitchToggleStyle(
                  tint: viewStore.isEndDateActive
                  ? Color(asset: LoveBirdAsset.green193)
                  : Color(asset: LoveBirdAsset.gray03)
                )
              )
          }

          if viewStore.isEndDateActive {
            HStack {
              Image(asset: LoveBirdAsset.icCalendar)

              Text(viewStore.endDate.to(dateFormat: Date.Format.YMD))
                .font(.pretendard(size: 18))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(viewStore.focusedType == .endDate ? Color(asset: LoveBirdAsset.green246) : Color(asset: LoveBirdAsset.gray03))
            .cornerRadius(12)
          }
        }
      }
      .onTapGesture {
        viewStore.send(.contentTapped(.endDate))
      }
    }
  }
}

#Preview {
  ScheduleAddEndDateView(
    store: .init(
      initialState: ScheduleAddState(schedule: .dummy),
      reducer: { ScheduleAddCore() }
    )
  )
}
