//
//  DiaryPreviewTabView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/08/18.
//

import ComposableArchitecture
import SwiftUI

struct DiaryPreviewTabView: View {
  let store: StoreOf<DiaryCore>

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      HStack(alignment: .center) {
        Button {
          viewStore.send(.previewFollowingTapped)
        } label: {
          Image(R.image.ic_navigate_previous_active)
            .changeColor(to: Color(R.color.gray08))
            .changeSize(to: .init(width: 44, height: 44))
        }

        Spacer()

        Text(String(viewStore.date.year) + "." + String(viewStore.date.month))
          .font(.pretendard(size: 16, weight: .bold))
          .foregroundColor(.black)

        Spacer()

        Button {
          viewStore.send(.previewNextTapped)
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
}

struct DiaryPreviewTabView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryPreviewTabView(
          store: Store(
            initialState: DiaryState(),
            reducer: DiaryCore()
          )
        )
    }
}
