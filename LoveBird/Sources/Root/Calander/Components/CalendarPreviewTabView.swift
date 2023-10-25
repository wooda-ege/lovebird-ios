//
//  CalendarPreviewTabView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/07/16.
//

import ComposableArchitecture
import SwiftUI

struct CalendarPreviewTabView: View {
  let store: StoreOf<CalendarCore>

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      HStack(alignment: .center) {
        Button {
          viewStore.send(.previewFollowingTapped)
        } label: {
          Image(asset: LoveBirdAsset.icNavigatePreviousActive)
            .changeColor(to: Color(asset: LoveBirdAsset.gray08))
            .changeSize(to: .init(width: 44, height: 44))
        }

        Spacer()

        Text(String(viewStore.currentPreviewDate.year) + "." + String(viewStore.currentPreviewDate.month))
          .font(.pretendard(size: 16, weight: .bold))
          .foregroundColor(.black)

        Spacer()

        Button {
          viewStore.send(.previewNextTapped)
        } label: {
          Image(asset: LoveBirdAsset.icNavigateNextActive)
            .changeColor(to: Color(asset: LoveBirdAsset.gray08))
            .changeSize(to: .init(width: 44, height: 44))
        }
      }
      .padding(8)
      .frame(width: 237, alignment: .center)
      .background(Color(asset: LoveBirdAsset.gray03))
      .cornerRadius(12)

    }
  }
}


#Preview {
	CalendarPreviewTabView(
		store: Store(
			initialState: CalendarState(),
			reducer: { CalendarCore() }
		)
	)
}
