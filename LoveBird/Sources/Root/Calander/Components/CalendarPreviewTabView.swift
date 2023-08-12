//
//  CalendarPreviewTabView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/07/16.
//

import ComposableArchitecture
import SwiftUI

struct CalendarPreviewTabView: View {
  let viewStore: ViewStore<CalendarState, CalendarAction>

  var body: some View {
    HStack(alignment: .center) {
      Button {
        self.viewStore.send(.previewFollowingTapped)
      } label: {
        Image(R.image.ic_navigate_previous_active)
          .changeColor(to: Color(R.color.gray08))
          .changeSize(to: .init(width: 44, height: 44))
      }

      Spacer()

      Text(String(viewStore.currentPreviewDate.year) + "." + String(viewStore.currentPreviewDate.month))
        .font(.pretendard(size: 16, weight: .bold))
        .foregroundColor(.black)

      Spacer()

      Button {
        self.viewStore.send(.previewNextTapped)
      } label: {
        Image(R.image.ic_navigate_next_active)
          .changeColor(to: Color(R.color.gray08))
          .changeSize(to: .init(width: 44, height: 44))
      }
    }
    .padding(8)
    .frame(width: 237, alignment: .center)
    .background(Color(R.color.gray03))
    .cornerRadius(12)
  }
}

//struct CalendarPreviewTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        CalendarPreviewTabView()
//    }
//}
