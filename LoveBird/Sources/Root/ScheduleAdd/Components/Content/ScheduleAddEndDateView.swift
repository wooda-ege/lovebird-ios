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
            Text(R.string.localizable.add_schedule_end_date)
              .font(.pretendard(size: 16))
              .foregroundColor(viewStore.focusedType == .endDate ? .black : Color(R.color.gray06))

            Toggle(
              isOn: viewStore.binding(
                get: \.isEndDateActive,
                send: ScheduleAddAction.endDateToggleTapped
              )
            ) { EmptyView() }
              .toggleStyle(
                SwitchToggleStyle(
                  tint: viewStore.isEndDateActive
                  ? Color(R.color.green193)
                  : Color(R.color.gray03)
                )
              )
          }

          if viewStore.isEndDateActive {
            HStack {
              Image(R.image.ic_calendar)

              Text(viewStore.endDate.to(dateFormat: Date.Format.YMD))
                .font(.pretendard(size: 18))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(viewStore.focusedType == .endDate ? Color(R.color.green246) : Color(R.color.gray03))
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

struct ScheduleAddEndDateView_Previews: PreviewProvider {
    static var previews: some View {
      ScheduleAddEndDateView(
        store: .init(
          initialState: ScheduleAddState(schedule: .dummy),
          reducer: ScheduleAddCore()
        )
      )
    }
}
