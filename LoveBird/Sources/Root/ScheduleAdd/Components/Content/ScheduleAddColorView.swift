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
        Text(LoveBirdStrings.addScheduleColor)
          .font(.pretendard(size: 16))
          .foregroundColor(viewStore.focusedType == .color ? .black : Color(asset: LoveBirdAsset.gray06))
          .frame(maxWidth: .infinity, alignment: .leading)

        Circle()
          .fill(viewStore.color.color)
          .frame(width: 12, height: 12)

        Text(viewStore.color.description)
          .font(.pretendard(size: 16, weight: .bold))
          .foregroundColor(.black)

        Image(asset: LoveBirdAsset.icArrowDropDown)
      }
      .onTapGesture {
        viewStore.send(.contentTapped(.color))
      }
    }
  }
}

#Preview {
  ScheduleAddColorView(
    store: .init(
      initialState: ScheduleAddState(schedule: .dummy),
      reducer: { ScheduleAddCore() }
    )
  )
}
