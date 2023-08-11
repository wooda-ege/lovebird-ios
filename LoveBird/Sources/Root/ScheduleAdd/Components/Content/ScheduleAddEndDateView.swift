//
//  ScheduleAddEndDateView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/07/01.
//

import ComposableArchitecture
import SwiftUI

struct ScheduleAddEndDateView: View {

  let viewStore: ViewStore<ScheduleAddState, ScheduleAddAction>
  let isFocused: Bool
  let isOn: Binding<Bool>

  init(viewStore: ViewStore<ScheduleAddState, ScheduleAddAction>) {
    self.viewStore = viewStore
    self.isFocused = viewStore.focusedType == .endDate
    self.isOn = viewStore.binding(get: \.isEndDateActive, send: ScheduleAddAction.endDateToggleTapped)
  }

  var body: some View {
    ScheduleFocusedView(isFocused: self.isFocused) {
      VStack {
        HStack {
          Text(R.string.localizable.add_schedule_end_date)
            .font(.pretendard(size: 16))
            .foregroundColor(self.isFocused ? .black : Color(R.color.gray06))

          Toggle(isOn: self.isOn) { EmptyView() }
            .toggleStyle(SwitchToggleStyle(tint: self.isOn.wrappedValue ? Color(R.color.green193) : Color(R.color.gray03)))
        }

        if self.viewStore.isEndDateActive {
          HStack {
            Image(R.image.ic_calendar)

            Text(self.viewStore.endDate.to(dateFormat: Date.Format.YMD))
              .font(.pretendard(size: 18))
              .foregroundColor(.black)
              .frame(maxWidth: .infinity, alignment: .leading)
          }
          .padding(.horizontal, 16)
          .padding(.vertical, 12)
          .background(self.isFocused ? Color(R.color.green246) : Color(R.color.gray03))
          .cornerRadius(12)
        }
      }
    }
    .onTapGesture {
      self.viewStore.send(.contentTapped(.endDate))
    }
  }
}

//struct AddScheduleEndDateView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddScheduleEndDateView()
//    }
//}
