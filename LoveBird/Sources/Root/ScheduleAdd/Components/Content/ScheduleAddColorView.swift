//
//  ScheduleAddColorView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/07/01.
//

import ComposableArchitecture
import SwiftUI

struct ScheduleAddColorView: View {
  
  let viewStore: ViewStore<ScheduleAddState, ScheduleAddAction>
  let isFocused: Bool

  init(viewStore: ViewStore<ScheduleAddState, ScheduleAddAction>) {
    self.viewStore = viewStore
    self.isFocused = viewStore.focusedType == .color
  }

  var body: some View {
    ScheduleFocusedView(isFocused: self.isFocused) {
      Text(R.string.localizable.add_schedule_color)
        .font(.pretendard(size: 16))
        .foregroundColor(self.isFocused ? .black : Color(R.color.gray06))
        .frame(maxWidth: .infinity, alignment: .leading)

      Circle()
        .fill(self.viewStore.color.color)
        .frame(width: 12, height: 12)

      Text(self.viewStore.color.description)
        .font(.pretendard(size: 16, weight: .bold))
        .foregroundColor(.black)

      Image(R.image.ic_arrow_drop_down)
    }
    .onTapGesture {
      self.viewStore.send(.contentTapped(.color))
    }
  }
}

//struct AddScheduleColorView_Previews: PreviewProvider {
//  static var previews: some View {
//    AddScheduleColorView()
//  }
//}
