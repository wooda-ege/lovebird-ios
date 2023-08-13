//
//  ScheduleAddAlarmView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/07/01.
//

import ComposableArchitecture
import SwiftUI

struct ScheduleAddAlarmView: View {

  let viewStore: ViewStore<ScheduleAddState, ScheduleAddAction>
  let isFocused: Bool
  let isOn: Binding<Bool>

  init(viewStore: ViewStore<ScheduleAddState, ScheduleAddAction>) {
    self.viewStore = viewStore
    self.isFocused = viewStore.focusedType == .alarm
    self.isOn = viewStore.binding(get: \.isAlarmActive, send: ScheduleAddAction.alarmToggleTapped)
  }

  var body: some View {
    ScheduleFocusedView(isFocused: self.isFocused) {
      VStack {
        HStack {
          Text(R.string.localizable.add_schedule_alarm)
            .font(.pretendard(size: 16))
            .foregroundColor(self.isFocused ? .black : Color(R.color.gray06))

          Toggle(isOn: self.isOn) { EmptyView() }
            .toggleStyle(SwitchToggleStyle(tint: self.isOn.wrappedValue ? Color(R.color.gray01) : Color(R.color.gray03)))
        }

        if self.viewStore.isAlarmActive {
          HStack {
            Text(self.viewStore.alarm.description)
              .font(.pretendard(size: 16))

            Spacer()

            Image(R.image.ic_arrow_drop_down)
              .resizable()
              .frame(width: 24, height: 24)
          }
          .padding(.horizontal, 16)
          .padding(.vertical, 12)
          .background(self.isFocused ? Color(R.color.gray01) : Color(R.color.gray03))
          .cornerRadius(12)
          .onTapGesture {
            self.viewStore.send(.alarmOptionTapped)
          }
        }
      }
    }
    .onTapGesture {
      self.viewStore.send(.contentTapped(.alarm))
    }
  }
}

//struct AddScheduleAlarmView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddScheduleAlarmView()
//    }
//}
