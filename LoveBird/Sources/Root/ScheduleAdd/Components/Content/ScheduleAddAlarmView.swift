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
            Text(R.string.localizable.add_schedule_alarm)
              .font(.pretendard(size: 16))
              .foregroundColor(viewStore.focusedType == .alarm ? .black : Color(R.color.gray06))

            Toggle(isOn: viewStore.binding(
              get: \.isAlarmActive,
              send: ScheduleAddAction.alarmToggleTapped
            )) { EmptyView() }
              .toggleStyle(
                SwitchToggleStyle(
                  tint: viewStore.isAlarmActive
                    ? Color(R.color.gray01)
                    : Color(R.color.gray03)
                )
              )
          }

          if viewStore.isAlarmActive {
            HStack {
              Text(viewStore.alarm.description)
                .font(.pretendard(size: 16))

              Spacer()

              Image(R.image.ic_arrow_drop_down)
                .resizable()
                .frame(width: 24, height: 24)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(viewStore.focusedType == .alarm ? Color(R.color.gray01) : Color(R.color.gray03))
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

struct ScheduleAddAlarmView_Previews: PreviewProvider {
  static var previews: some View {
    ScheduleAddAlarmView(
      store: .init(
        initialState: ScheduleAddState(schedule: .dummy),
        reducer: ScheduleAddCore()
      )
    )
  }
}
