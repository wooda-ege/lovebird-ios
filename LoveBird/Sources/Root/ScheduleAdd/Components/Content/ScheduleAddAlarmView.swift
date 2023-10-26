//
//  ScheduleAddAlarmView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/07/01.
//

import ComposableArchitecture
import SwiftUI

struct ScheduleAddAlarmView: View {
  let store: StoreOf<ScheduleAddCore>

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      CommonFocusedView(isFocused: viewStore.focusedType == .alarm) {
        VStack {
          HStack {
            Text(LoveBirdStrings.addScheduleAlarm)
              .font(.pretendard(size: 16))
              .foregroundColor(viewStore.focusedType == .alarm ? .black : Color(asset: LoveBirdAsset.gray06))

            Toggle(isOn: viewStore.binding(
              get: \.isAlarmActive,
              send: ScheduleAddAction.alarmToggleTapped
            )) { EmptyView() }
              .toggleStyle(
                SwitchToggleStyle(
                  tint: viewStore.isAlarmActive
                    ? Color(asset: LoveBirdAsset.gray01)
                    : Color(asset: LoveBirdAsset.gray03)
                )
              )
          }

          if viewStore.isAlarmActive {
            HStack {
              Text(viewStore.alarm.description)
                .font(.pretendard(size: 16))

              Spacer()

              Image(asset: LoveBirdAsset.icArrowDropDown)
                .resizable()
                .frame(width: 24, height: 24)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(viewStore.focusedType == .alarm ? Color(asset: LoveBirdAsset.gray01) : Color(asset: LoveBirdAsset.gray03))
            .cornerRadius(12)
            .onTapGesture {
              viewStore.send(.alarmOptionTapped)
            }
          }
        }
      }
      .onTapGesture {
        viewStore.send(.contentTapped(.alarm))
      }
    }
  }
}

#Preview {
  ScheduleAddAlarmView(
    store: .init(
      initialState: ScheduleAddState(schedule: .dummy),
      reducer: { ScheduleAddCore() }
    )
  )
}
