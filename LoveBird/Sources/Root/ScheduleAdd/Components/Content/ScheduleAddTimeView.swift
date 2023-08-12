//
//  AddScheduleTimeView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/07/01.
//

import ComposableArchitecture
import SwiftUI

struct ScheduleAddTimeView: View {

  let viewStore: ViewStore<ScheduleAddState, ScheduleAddAction>
  let isFocused: Bool
  let isOn: Binding<Bool>

  init(viewStore: ViewStore<ScheduleAddState, ScheduleAddAction>) {
    self.viewStore = viewStore
    self.isFocused = viewStore.focusedType.isTime
    self.isOn = viewStore.binding(get: \.isTimeActive, send: ScheduleAddAction.timeToggleTapped)
  }

  var body: some View {
    ScheduleFocusedView(isFocused: self.viewStore.focusedType.isTime) {
      VStack(spacing: 16) {
        HStack {
          Text(R.string.localizable.add_schedule_time)
            .font(.pretendard(size: 16))
            .foregroundColor(self.isFocused ? .black : Color(R.color.gray06))

          Toggle(isOn: self.viewStore.binding(get: \.isTimeActive, send: ScheduleAddAction.timeToggleTapped)) { EmptyView() }
            .toggleStyle(SwitchToggleStyle(tint: self.isOn.wrappedValue ? Color(R.color.green193) : Color(R.color.gray03)))
        }

        if self.viewStore.isTimeActive {
          HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 8) {
              HStack(alignment: .bottom, spacing: 4) {
                Text(R.string.localizable.add_schedule_start_time)
                  .font(.pretendard(size: 14, weight: .bold))
                  .foregroundColor(Color(R.color.gray06))

                if self.viewStore.isEndDateActive {
                  Text(self.viewStore.startDate.to(dateFormat: Date.Format.YMDDotted))
                    .font(.pretendard(size: 12, weight: .bold))
                    .foregroundColor(Color(R.color.secondary))
                }
              }

              Text(self.viewStore.startTime.format)
              .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(12)
            .frame(maxWidth: .infinity)
            .background(self.isFocused ? Color(R.color.green246) : Color(R.color.gray03))
            .cornerRadius(12)
            .onTapGesture {
              self.viewStore.send(.contentTapped(.startTime))
            }

            VStack(alignment: .leading, spacing: 8) {
              HStack(alignment: .bottom, spacing: 4) {
                Text(R.string.localizable.add_schedule_end_time)
                  .font(.pretendard(size: 14, weight: .bold))
                  .foregroundColor(Color(R.color.gray06))

                if self.viewStore.isEndDateActive {
                  Text(self.viewStore.endDate.to(dateFormat: Date.Format.YMDDotted))
                    .font(.pretendard(size: 12, weight: .bold))
                    .foregroundColor(Color(R.color.secondary))
                }
              }

              Text(self.viewStore.endTime.format)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(12)
            .frame(maxWidth: .infinity)
            .background(self.isFocused ? Color(R.color.green246) : Color(R.color.gray03))
            .cornerRadius(12)
            .onTapGesture {
              self.viewStore.send(.contentTapped(.endTime))
            }
          }
        }
      }
    }
    .onTapGesture {
      self.viewStore.send(.contentTapped(.time))
    }
  }
}

//struct AddScheduleTimeView_Previews: PreviewProvider {
//  static var previews: some View {
//    AddScheduleTimeView()
//  }
//}
