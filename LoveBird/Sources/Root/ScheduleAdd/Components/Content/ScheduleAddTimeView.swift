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
            Text(R.string.localizable.add_schedule_time)
              .font(.pretendard(size: 16))
              .foregroundColor(viewStore.focusedType.isTime ? .black : Color(R.color.gray06))

            Toggle(
              isOn: viewStore.binding(
                get: \.isTimeActive,
                send: ScheduleAddAction.timeToggleTapped
              )
            ) { EmptyView() }
              .toggleStyle(
                SwitchToggleStyle(
                  tint: viewStore.isTimeActive
                    ? Color(R.color.green193)
                    : Color(R.color.gray03)
                )
              )
          }

          if viewStore.isTimeActive {
            HStack(spacing: 8) {
              VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .bottom, spacing: 4) {
                  Text(R.string.localizable.add_schedule_start_time)
                    .font(.pretendard(size: 14, weight: .bold))
                    .foregroundColor(Color(R.color.gray06))

                  if viewStore.isEndDateActive {
                    Text(viewStore.startDate.to(dateFormat: Date.Format.YMDDotted))
                      .font(.pretendard(size: 12, weight: .bold))
                      .foregroundColor(Color(R.color.secondary))
                  }
                }

                Text(viewStore.startTime.format)
                .frame(maxWidth: .infinity, alignment: .leading)
              }
              .padding(12)
              .frame(maxWidth: .infinity)
              .background(viewStore.focusedType.isTime ? Color(R.color.green246) : Color(R.color.gray03))
              .cornerRadius(12)
              .onTapGesture {
                viewStore.send(.contentTapped(.startTime))
              }

              VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .bottom, spacing: 4) {
                  Text(R.string.localizable.add_schedule_end_time)
                    .font(.pretendard(size: 14, weight: .bold))
                    .foregroundColor(Color(R.color.gray06))

                  if viewStore.isEndDateActive {
                    Text(viewStore.endDate.to(dateFormat: Date.Format.YMDDotted))
                      .font(.pretendard(size: 12, weight: .bold))
                      .foregroundColor(Color(R.color.secondary))
                  }
                }

                Text(viewStore.endTime.format)
                  .frame(maxWidth: .infinity, alignment: .leading)
              }
              .padding(12)
              .frame(maxWidth: .infinity)
              .background(viewStore.focusedType.isTime ? Color(R.color.green246) : Color(R.color.gray03))
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

struct ScheduleAddTimeView_Previews: PreviewProvider {
  static var previews: some View {
    ScheduleAddTimeView(
      store: .init(
        initialState: ScheduleAddState(schedule: .dummy),
        reducer: ScheduleAddCore()
      )
    )
  }
}
