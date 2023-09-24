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
    CommonFocusedView(isFocused: self.viewStore.focusedType.isTime) {
      VStack(spacing: 16) {
        HStack {
          Text(LoveBirdStrings.addScheduleTime)
            .font(.pretendard(size: 16))
            .foregroundColor(self.isFocused ? .black : Color(asset: LoveBirdAsset.gray06))

          Toggle(isOn: self.viewStore.binding(get: \.isTimeActive, send: ScheduleAddAction.timeToggleTapped)) { EmptyView() }
            .toggleStyle(SwitchToggleStyle(tint: self.isOn.wrappedValue ? Color(asset: LoveBirdAsset.green193) : Color(asset: LoveBirdAsset.gray03)))
        }

        if self.viewStore.isTimeActive {
          HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 8) {
              HStack(alignment: .bottom, spacing: 4) {
                Text(LoveBirdStrings.addScheduleStartTime)
                  .font(.pretendard(size: 14, weight: .bold))
                  .foregroundColor(Color(asset: LoveBirdAsset.gray06))

                if self.viewStore.isEndDateActive {
                  Text(self.viewStore.startDate.to(dateFormat: Date.Format.YMDDotted))
                    .font(.pretendard(size: 12, weight: .bold))
                    .foregroundColor(Color(asset: LoveBirdAsset.secondary))
                }
              }

              Text(self.viewStore.startTime.format)
              .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(12)
            .frame(maxWidth: .infinity)
            .background(self.isFocused ? Color(asset: LoveBirdAsset.green246) : Color(asset: LoveBirdAsset.gray03))
            .cornerRadius(12)
            .onTapGesture {
              self.viewStore.send(.contentTapped(.startTime))
            }

            VStack(alignment: .leading, spacing: 8) {
              HStack(alignment: .bottom, spacing: 4) {
                Text(LoveBirdStrings.addScheduleEndTime)
                  .font(.pretendard(size: 14, weight: .bold))
                  .foregroundColor(Color(asset: LoveBirdAsset.gray06))

                if self.viewStore.isEndDateActive {
                  Text(self.viewStore.endDate.to(dateFormat: Date.Format.YMDDotted))
                    .font(.pretendard(size: 12, weight: .bold))
                    .foregroundColor(Color(asset: LoveBirdAsset.secondary))
                }
              }

              Text(self.viewStore.endTime.format)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(12)
            .frame(maxWidth: .infinity)
            .background(self.isFocused ? Color(asset: LoveBirdAsset.green246) : Color(asset: LoveBirdAsset.gray03))
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
