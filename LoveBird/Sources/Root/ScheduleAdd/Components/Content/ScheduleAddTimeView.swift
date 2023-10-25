//
//  AddScheduleTimeView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/07/01.
//

import ComposableArchitecture
import SwiftUI

struct ScheduleAddTimeView: View {
  let store: StoreOf<ScheduleAddCore>

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      CommonFocusedView(isFocused: viewStore.focusedType.isTime) {
        VStack(spacing: 16) {
          HStack {
            Text(LoveBirdStrings.addScheduleTime)
              .font(.pretendard(size: 16))
              .foregroundColor(viewStore.focusedType.isTime ? .black : Color(asset: LoveBirdAsset.gray06))

            Toggle(
              isOn: viewStore.binding(
                get: \.isTimeActive,
                send: ScheduleAddAction.timeToggleTapped
              )
            ) { EmptyView() }
              .toggleStyle(
                SwitchToggleStyle(
                  tint: viewStore.isTimeActive
                    ? Color(asset: LoveBirdAsset.green193)
                    : Color(asset: LoveBirdAsset.gray03)
                )
              )
          }

          if viewStore.isTimeActive {
            HStack(spacing: 8) {
              VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .bottom, spacing: 4) {
                  Text(LoveBirdStrings.addScheduleStartTime)
                    .font(.pretendard(size: 14, weight: .bold))
                    .foregroundColor(Color(asset: LoveBirdAsset.gray06))

                  if viewStore.isEndDateActive {
                    Text(viewStore.startDate.to(dateFormat: Date.Format.YMDDotted))
                      .font(.pretendard(size: 12, weight: .bold))
                      .foregroundColor(Color(asset: LoveBirdAsset.secondary))
                  }
                }

                Text(viewStore.startTime.format)
                .frame(maxWidth: .infinity, alignment: .leading)
              }
              .padding(12)
              .frame(maxWidth: .infinity)
              .background(viewStore.focusedType.isTime ? Color(asset: LoveBirdAsset.green246) : Color(asset: LoveBirdAsset.gray03))
              .cornerRadius(12)
              .onTapGesture {
                viewStore.send(.contentTapped(.startTime))
              }

              VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .bottom, spacing: 4) {
                  Text(LoveBirdStrings.addScheduleEndTime)
                    .font(.pretendard(size: 14, weight: .bold))
                    .foregroundColor(Color(asset: LoveBirdAsset.gray06))

                  if viewStore.isEndDateActive {
                    Text(viewStore.endDate.to(dateFormat: Date.Format.YMDDotted))
                      .font(.pretendard(size: 12, weight: .bold))
                      .foregroundColor(Color(asset: LoveBirdAsset.secondary))
                  }
                }

                Text(viewStore.endTime.format)
                  .frame(maxWidth: .infinity, alignment: .leading)
              }
              .padding(12)
              .frame(maxWidth: .infinity)
              .background(viewStore.focusedType.isTime ? Color(asset: LoveBirdAsset.green246) : Color(asset: LoveBirdAsset.gray03))
              .cornerRadius(12)
              .onTapGesture {
                viewStore.send(.contentTapped(.endTime))
              }
            }
          }
        }
      }
      .onTapGesture {
        viewStore.send(.contentTapped(.time))
      }
    }
  }
}

#Preview {
	ScheduleAddTimeView(
		store: .init(
			initialState: ScheduleAddState(schedule: .dummy),
			reducer: { ScheduleAddCore() }
		)
	)
}
