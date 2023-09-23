//
//  ScheduleAddColorView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/07/01.
//

import ComposableArchitecture
import SwiftUI

struct ScheduleAddColorView: View {
  let store: StoreOf<ScheduleAddCore>

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      CommonFocusedView(isFocused: viewStore.focusedType == .color) {
        Text(R.string.localizable.add_schedule_color)
          .font(.pretendard(size: 16))
          .foregroundColor(viewStore.focusedType == .color ? .black : Color(R.color.gray06))
          .frame(maxWidth: .infinity, alignment: .leading)

        Circle()
          .fill(viewStore.color.color)
          .frame(width: 12, height: 12)

        Text(viewStore.color.description)
          .font(.pretendard(size: 16, weight: .bold))
          .foregroundColor(.black)

        Image(R.image.ic_arrow_drop_down)
      }
      .onTapGesture {
        viewStore.send(.contentTapped(.color))
      }
    }
  }
}

struct ScheduleAddColorView_Previews: PreviewProvider {
  static var previews: some View {
    ScheduleAddColorView(
      store: .init(
        initialState: ScheduleAddState(schedule: .dummy),
        reducer: ScheduleAddCore()
      )
    )
  }
}
